"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MissionTestGateway = void 0;
const common_1 = require("@nestjs/common");
const websockets_1 = require("@nestjs/websockets");
const socket_io_1 = require("socket.io");
const testdata = require("./mission.testdata.json");
let MissionTestGateway = class MissionTestGateway {
    constructor() {
        this.logger = new common_1.Logger('TestGateway');
        this.clients = new Map();
        this.clientCnt = 0;
        this.isClientConnected = false;
    }
    handleConnection(client, ...args) {
        this.clientCnt++;
        this.isClientConnected = true;
        this.logger.log(`Testclient connected | ${client.id}`);
    }
    handleDisconnect(client) {
        this.clients.delete(client);
        this.clientCnt--;
        if (this.clientCnt <= 0) {
            this.isClientConnected = false;
        }
        this.logger.log(`Testclient disconnected | ${client.id}`);
    }
    async handleMessage(client, payload) {
        let alarms = testdata;
        const access_token = JSON.parse(payload)['token'];
        if (access_token != undefined && access_token != null && access_token != "") {
            const payloadBuffer = Buffer.from(payload, "base64");
            const firestation = payloadBuffer.toString().split('firestation":"')[1].split('"')[0];
            if (firestation != undefined && firestation != null && firestation != "") {
                this.clients.set(client, access_token);
                while (this.isClientConnected) {
                    for (let el of this.clients.keys()) {
                        let alarmCnt = alarms['cnt_einsaetze'];
                        for (let i = 0; i < alarmCnt; i++) {
                            if (alarms['einsaetze'][i]['einsatz']['status'] == 'offen') {
                                if (JSON.stringify(alarms['einsaetze'][i]['einsatz']).includes(firestation)) {
                                    el.emit('ownMissionResponse', alarms['einsaetze'][i]['einsatz']);
                                }
                            }
                        }
                    }
                    await new Promise(f => setTimeout(f, 15000));
                }
            }
            else {
                client.disconnect();
            }
        }
        else {
            client.disconnect();
        }
    }
};
__decorate([
    (0, websockets_1.WebSocketServer)(),
    __metadata("design:type", socket_io_1.Server)
], MissionTestGateway.prototype, "wss", void 0);
__decorate([
    (0, websockets_1.SubscribeMessage)('ownMissionRequest'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [socket_io_1.Socket, String]),
    __metadata("design:returntype", Promise)
], MissionTestGateway.prototype, "handleMessage", null);
MissionTestGateway = __decorate([
    (0, websockets_1.WebSocketGateway)({ cors: true, namespace: '/testmissions' })
], MissionTestGateway);
exports.MissionTestGateway = MissionTestGateway;
//# sourceMappingURL=mission.testgateway.js.map