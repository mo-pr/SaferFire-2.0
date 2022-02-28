import { Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, OnGatewayInit, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import axios, { AxiosResponse } from 'axios';
import { JwtService } from '@nestjs/jwt';
import { delay } from 'rxjs';

@WebSocketGateway({cors: true, namespace:'/alarms'})
export class AlarmsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect{
  constructor(private jwtService:JwtService){}
  
  @WebSocketServer() wss: Server;
  private logger:Logger = new Logger('AlarmGateway');

  private clients = new Map();
  private clientCnt = 0;
  private isClientConnected = false;

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
    if(access_token != undefined || access_token != null){
      const isValid = await this.jwtService.verifyAsync(access_token)
      if(isValid){
        this.clients.set(client,access_token);
        while(this.isClientConnected){
          console.log(this.clients.size);
          await this.getAlarms().then(x=>alarms=x);
          for(let el of this.clients.keys()){
            console.log(el.id);
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
}
