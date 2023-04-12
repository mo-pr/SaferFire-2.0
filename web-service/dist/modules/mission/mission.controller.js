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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MissionController = void 0;
const common_1 = require("@nestjs/common");
const mission_service_1 = require("./mission.service");
const mission_helper_1 = require("./mission.helper");
const mission_dto_1 = require("./mission.dto");
let MissionController = class MissionController {
    constructor(missionService) {
        this.missionService = missionService;
        this.logger = new common_1.Logger('MissionController');
    }
    async writeAllAlarms() {
        let helper = new mission_helper_1.MissionHelper();
        let missions = await helper.extractAlarms();
        try {
            missions.forEach(async (mission) => await this.missionService.saveMission(mission));
        }
        catch (error) {
            this.logger.error("Error writing missions to database" + error.message);
            throw new common_1.HttpException('Missions could not be written to database!', common_1.HttpStatus.BAD_REQUEST);
        }
        this.logger.log("Missions written to database");
        throw new common_1.HttpException('Missions successfully written to database.', common_1.HttpStatus.OK);
    }
    async getByfiredepartment(payload) {
        if (payload.firedepartment == null || payload.firedepartment == "") {
            throw new common_1.HttpException('Firedepartment is a required input!', common_1.HttpStatus.BAD_REQUEST);
        }
        let missions = await this.missionService.getMissionsByDepartment(payload.firedepartment);
        this.logger.log('Missions successfully read from database.');
        return missions;
    }
};
__decorate([
    (0, common_1.Get)('/writemissions'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], MissionController.prototype, "writeAllAlarms", null);
__decorate([
    (0, common_1.Post)('/getbyfiredepartment'),
    (0, common_1.HttpCode)(200),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [mission_dto_1.FiredepartmentBody]),
    __metadata("design:returntype", Promise)
], MissionController.prototype, "getByfiredepartment", null);
MissionController = __decorate([
    (0, common_1.Controller)('mission'),
    __metadata("design:paramtypes", [mission_service_1.MissionService])
], MissionController);
exports.MissionController = MissionController;
//# sourceMappingURL=mission.controller.js.map