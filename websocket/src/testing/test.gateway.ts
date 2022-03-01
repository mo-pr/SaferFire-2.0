import { Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, OnGatewayInit, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import axios, { AxiosResponse } from 'axios';
import { JwtService } from '@nestjs/jwt';
import { Connection } from "typeorm";
import testdata = require("./testdata.json");

@WebSocketGateway(4040, { cors: true, namespace: '/alarms' })
export class TestGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  constructor(private conn: Connection, private jwtService: JwtService) { }

  @WebSocketServer() wss: Server;
  private logger: Logger = new Logger('TestGateway');

  private clients = new Map();
  private clientCnt = 0;
  private isClientConnected = false;

  afterInit(server: Server) {
    this.logger.log('Initialized');
  }
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

  @SubscribeMessage('alarmsReq')
  async handleMessage(client: Socket, payload: string) {
    let alarms = testdata;
    const access_token = JSON.parse(payload)['token'];
    const amount = JSON.parse(payload)['count'] > 20 ? 20:JSON.parse(payload)['count'];
    if (access_token != undefined || access_token != null) {
      const isValid = await this.jwtService.verifyAsync(access_token)
      if (isValid) {
        this.clients.set(client, access_token);
        while (this.isClientConnected) {
          let count = 0;
          for (let el of this.clients.keys()) {
            let alarmCnt = alarms['cnt_einsaetze'];
            for (let i = 0; i < alarmCnt&&i<amount; i++) {
              //if(alarms['einsaetze'][i]['einsatz']['status'] == 'offen'){
              if (JSON.stringify(alarms['einsaetze'][i]['einsatz']).includes(this.jwtService.decode(access_token)['firestation'])) {
                count++;
                el.emit('alarmsRes', alarms['einsaetze'][i]['einsatz']);
              }
              //}
            }
          }
          await new Promise(f => setTimeout(f, 15000));
        }
      }
      else {
        client.disconnect();
      }
    }
  }
}
