import { Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Cron } from '@nestjs/schedule';
import { MissionHelper } from './mission.helper';
import { MissionService } from './mission.service';

@WebSocketGateway({cors: true, namespace:'/missions'})
export class MissionGateway implements OnGatewayConnection, OnGatewayDisconnect{
    constructor(private missionService:MissionService) {}

    @WebSocketServer() wss: Server;
    private logger:Logger = new Logger('MissionGateway');
    private helper = new MissionHelper();
    private clients = new Map();
    private clientCnt = 0;
    private isClientConnected = false;

    @Cron('1-3 50 23 * * *')
    async handleCron(){
        
        let missions = await this.helper.extractAlarms()
        try{
            missions.forEach(async (mission) => await this.missionService.saveMission(mission))
        }
        catch(error){
            this.logger.error("(CRON) Error writing missions to database"+error.message)
        }
        this.logger.log("(CRON) Missions written to database")
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

    @SubscribeMessage('ownMissionRequest')
    async handleOwnMessage(client: Socket, payload:string){
        let alarms:String;
        const access_token = JSON.parse(payload)['token'];  
        if(access_token != undefined && access_token != null && access_token!=""){   
            const payloadBuffer = Buffer.from(payload, "base64");
            const firestation = payloadBuffer.toString().split('firestation":"')[1].split('"')[0]
            if(firestation!= undefined && firestation != null && firestation != ""){
                this.clients.set(client,access_token);
                while(this.isClientConnected){
                    await this.helper.getAlarms(true).then((x)=>alarms=x);
                    for(let el of this.clients.keys()){
                        let alarmCnt = alarms['cnt_einsaetze'];
                        for(let i = 0; i < alarmCnt;i++){
                        if(alarms['einsaetze'][i]['einsatz']['status'] == 'offen'){
                            if(JSON.stringify(alarms['einsaetze'][i]['einsatz']).includes(firestation)){
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
        }else{
            client.disconnect();
        }
    }
}

