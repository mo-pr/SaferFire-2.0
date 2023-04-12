import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MissionService } from './mission.service';
export declare class MissionGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private missionService;
    constructor(missionService: MissionService);
    wss: Server;
    private logger;
    private helper;
    private clients;
    private clientCnt;
    private isClientConnected;
    handleCron(): Promise<void>;
    handleConnection(client: Socket, ...args: any[]): void;
    handleDisconnect(client: Socket): void;
    handleOwnMessage(client: Socket, payload: string): Promise<void>;
}
