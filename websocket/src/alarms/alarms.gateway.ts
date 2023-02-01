import { Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, OnGatewayInit, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import axios, { AxiosResponse } from 'axios';
import { JwtService } from '@nestjs/jwt';
import { Connection } from "typeorm";
import { Mission } from './Datamodel';
import { Cron } from '@nestjs/schedule';
import { CronJob } from 'cron';

@WebSocketGateway({cors: true, namespace:'/alarms'})
export class AlarmsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect{
  constructor(private conn: Connection, private jwtService:JwtService) {}
  
  @WebSocketServer() wss: Server;
  private logger:Logger = new Logger('AlarmGateway');

  private clients = new Map();
  private clientCnt = 0;
  private isClientConnected = false;

  @Cron('1-3 50 23 * * *')
  handleCron(){
    this.writeAlarmsToDatabase();
  }
  
  afterInit(server: Server) {
    this.logger.log('Initialized');
  }
  handleConnection(client: Socket, ...args: any[]) {
    this.clientCnt++;
    this.isClientConnected= true;
    this.logger.log(`Client connected | ${client.id}`);
  }
  handleDisconnect(client: Socket) {
    this.clients.delete(client);
    this.clientCnt--;
    if(this.clientCnt <= 0){
      this.isClientConnected = false;
    }
    this.logger.log(`Client disconnected | ${client.id}`);
  }

  @SubscribeMessage('alarmsReq')
  async handleMessage(client: Socket, payload:string){
    let alarms:String;
    const access_token = JSON.parse(payload)['token'];
    console.log(access_token);
    if(access_token != undefined || access_token != null){
      const isValid = await this.jwtService.verifyAsync(access_token)
      if(isValid){
        this.clients.set(client,access_token);
        while(this.isClientConnected){
          await this.getAlarms().then(x=>alarms=x);
          for(let el of this.clients.keys()){
            let alarmCnt = alarms['cnt_einsaetze'];
            for(let i = 0; i < alarmCnt;i++){
              if(alarms['einsaetze'][i]['einsatz']['status'] == 'offen'){
                if(JSON.stringify(alarms['einsaetze'][i]['einsatz']).includes(this.jwtService.decode(access_token)['firestation'])){
                  el.emit('alarmsRes',alarms['einsaetze'][i]['einsatz']);
                }
              }
            }
          }
          
          await new Promise(f => setTimeout(f, 15000));
        }
      }
      else{
        client.disconnect();
      }
    }
  }

  private async getAlarms(){
    const url ='https://cf-intranet.ooelfv.at/webext2/rss/json_2tage.txt';
    const getalarms = async ()  => {
      let result: AxiosResponse = await axios.get(url);
      return result.data;
    };
    return await getalarms();
  }

  public async writeAlarmsToDatabase(){
    let alarms,temp:String;
    let tempMission:Mission;
    this.logger.log("Writing Alarms to Database");
    await this.getAlarms().then(x=>alarms=x);
    let alarmCnt = alarms['cnt_einsaetze'];
    for(let i = 0; i < alarmCnt;i++){
      temp = alarms['einsaetze'][i]['einsatz'];
      let firedeps = [];
      for(let i = 0; i < temp['cntfeuerwehren'];i++){
        firedeps.push(temp['feuerwehrenarray'][i.toString()]['fwname']+`${temp['cntfeuerwehren']>1?"\n":""}`);
      }
      tempMission = new Mission();
      tempMission.Mission(temp['num1'],temp['startzeit'],temp['alarmstufe'],temp['einsatztyp']['text'],
        temp['einsatzsubtyp']['text'],temp['bezirk']['text'],temp['adresse']['efeanme'],temp['adresse']['estnum'],
        temp['adresse']['earea']+"/ "+temp['adresse']['emun'],temp['adresse']['ecompl'],
        temp['wgs84']['lng'],temp['wgs84']['lat'],firedeps.toString());
      const qRunner = this.conn.createQueryRunner();
      await qRunner.connect();
      await qRunner.startTransaction();
      try{
        const res = await qRunner.query(`INSERT INTO missiondata (mission_id,alarm_time,stage,alarmtype,alarmsubtype,district,street,street_no,
          area,additional_info,latitude,longitude,firedepartments) VALUES ('${tempMission.id}','${tempMission.time}',
          ${tempMission.stage},'${tempMission.alarmType}','${tempMission.alarmsubtype}','${tempMission.district}','${tempMission.street}',
          ${tempMission.street_no==""?-1:Number(tempMission.street_no)},'${tempMission.area}','${tempMission.additional_info}','${tempMission.latitude}',
          '${tempMission.longitude}','${tempMission.firedepartments}')`);
        await qRunner.commitTransaction();
      }catch(err){
        await qRunner.rollbackTransaction();
      }
      finally{
          await qRunner.release();
      }
    }
  }
}
