import { Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, OnGatewayInit, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import axios, { AxiosResponse } from 'axios';
import { JwtService } from '@nestjs/jwt';

@WebSocketGateway({cors: true, namespace:'/alarms'})
export class AlarmsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect{
  constructor(private jwtService:JwtService){}
  
  @WebSocketServer() wss: Server;
  private logger:Logger = new Logger('AlarmGateway');

  afterInit(server: Server) {
    this.logger.log('Initialized');
  } 
  handleConnection(client: Socket, ...args: any[]) {
    this.logger.log(`Client connected | ${client.id}`);
  }
  handleDisconnect(client: Socket) {
    this.logger.log(`Client disconnected | ${client.id}`);
  }

  @SubscribeMessage('alarmsReq')
  async handleMessage(client: Socket, payload:string){
    const access_token = JSON.parse(payload)['token'];
    if(access_token != undefined || access_token != null){
      const isValid = await this.jwtService.verifyAsync(access_token)
      if(isValid){
        this.getAlarms().then(x=>this.wss.emit('alarmsRes',x));
        this.logger.log(`Client ${client.id} requested alarms`);
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
