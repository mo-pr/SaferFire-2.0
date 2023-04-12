import { Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import testdata = require("./mission.testdata.json");

@WebSocketGateway({ cors: true, namespace: '/testmissions' })
export class MissionTestGateway implements OnGatewayConnection, OnGatewayDisconnect {

  @WebSocketServer() wss: Server;
  private logger: Logger = new Logger('TestGateway');

  private clients = new Map();
  private clientCnt = 0;
  private isClientConnected = false;

  handleConnection(client: Socket, ...args: any[]) {
    this.clientCnt++;
    this.isClientConnected = true;
    this.logger.log(`Testclient connected | ${client.id}`);
  }
  handleDisconnect(client: Socket) {
    this.clients.delete(client);
    this.clientCnt--;
    if (this.clientCnt <= 0) {
      this.isClientConnected = false;
    }
    this.logger.log(`Testclient disconnected | ${client.id}`);
  }

  @SubscribeMessage('ownMissionRequest')
  async handleMessage(client: Socket, payload: string) {
    let alarms = testdata;
    //const access_token = JSON.parse(payload)['token'];  
    //if(access_token != undefined && access_token != null && access_token!=""){   
        const payloadBuffer = Buffer.from(payload, "base64");
        const firestation = payloadBuffer.toString().split('firestation":"')[1].split('"')[0]
        console.log(firestation)
        if(firestation!= undefined && firestation != null && firestation != ""){
            //this.clients.set(client,access_token);
            while(this.isClientConnected){
              for(let el of this.clients.keys()){
                  let alarmCnt = alarms['cnt_einsaetze'];
                  for(let i = 0; i < alarmCnt;i++){
                    if(alarms['einsaetze'][i]['einsatz']['status'] == 'offen'){
                      if(JSON.stringify(alarms['einsaetze'][i]['einsatz']).includes('FF Test')){
                        el.emit('ownMissionResponse',alarms['einsaetze'][i]['einsatz']);
                      }
                    }
                  }
              }
              await new Promise(f => setTimeout(f, 15000));
            }
        }else{
            client.disconnect();
        }
    //}else{
        //client.disconnect();
    //}
  }
}
