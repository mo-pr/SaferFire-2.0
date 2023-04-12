import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
export declare class MissionTestGateway implements OnGatewayConnection, OnGatewayDisconnect {
    wss: Server;
    private logger;
    private clients;
    private clientCnt;
    private isClientConnected;
    handleConnection(client: Socket, ...args: any[]): void;
    handleDisconnect(client: Socket): void;
    handleMessage(client: Socket, payload: string): Promise<void>;
}
