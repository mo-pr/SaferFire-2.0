import { Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, OnGatewayInit, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import axios, { AxiosResponse } from 'axios';
import { JwtService } from '@nestjs/jwt';
import { Connection } from "typeorm";
import { Mission } from './Datamodel';
import { Cron } from '@nestjs/schedule';
import { CronJob } from 'cron';

@WebSocketGateway({cors: true, namespace:'/allalarms'})
export class AllAlarmsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect{
  constructor(private conn: Connection, private jwtService:JwtService) {}
  
  @WebSocketServer() wss: Server;
  private logger:Logger = new Logger('AllAlarmGateway');

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
    this.clientCnt--;
    if(this.clientCnt <= 0){
      this.isClientConnected = false;
    }
    this.logger.log(`Client disconnected | ${client.id}`);
  }

  @SubscribeMessage('alarmsReq')
  async handleMessage(client: Socket, payload:string){
    let alarms:String;
    while(this.isClientConnected){
        await this.getAlarms().then(x=>alarms=x);
        let alarmCnt = alarms['cnt_einsaetze'];
        for(let i = 0; i < alarmCnt;i++){
            this.wss.emit('alarmsRes',alarms['einsaetze'][i]['einsatz']);
        }
        await new Promise(f => setTimeout(f, 15000));
    }
  }

  private async getAlarms(){
    const url ='https://cf-intranet.ooelfv.at/webext2/rss/json_laufend.txt';
    const getalarms = async ()  => {
      let result: AxiosResponse = await axios.get(url);
      return result.data;
    };
    return await getalarms();
  }
}
