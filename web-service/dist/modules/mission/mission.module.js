"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MissionModule = void 0;
const common_1 = require("@nestjs/common");
const mission_controller_1 = require("./mission.controller");
const mission_service_1 = require("./mission.service");
const typeorm_1 = require("@nestjs/typeorm");
const mission_repository_1 = require("./mission.repository");
const mission_entity_1 = require("./mission.entity");
const mission_gateway_1 = require("./mission.gateway");
const mission_testgateway_1 = require("./mission.testgateway");
let MissionModule = class MissionModule {
};
MissionModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([mission_entity_1.Mission]),
        ],
        controllers: [mission_controller_1.MissionController],
        providers: [mission_service_1.MissionService, mission_repository_1.MissionRepository, mission_gateway_1.MissionGateway, mission_testgateway_1.MissionTestGateway,
        ]
    })
], MissionModule);
exports.MissionModule = MissionModule;
//# sourceMappingURL=mission.module.js.map