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
exports.DangerousgoodController = void 0;
const common_1 = require("@nestjs/common");
const nest_keycloak_connect_1 = require("nest-keycloak-connect");
const dangerousgood_service_1 = require("./dangerousgood.service");
let DangerousgoodController = class DangerousgoodController {
    constructor(dangerousgoodService) {
        this.dangerousgoodService = dangerousgoodService;
        this.logger = new common_1.Logger('DangerousgoodController');
    }
    async getAll() {
        let dangerousgoods = await this.dangerousgoodService.getAllDangerousgoods();
        this.logger.log('Dangerousgoods successfully read from database.');
        return dangerousgoods;
    }
};
__decorate([
    (0, common_1.Get)('/getall'),
    (0, common_1.HttpCode)(200),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], DangerousgoodController.prototype, "getAll", null);
DangerousgoodController = __decorate([
    (0, common_1.Controller)('dangerousgood'),
    (0, common_1.UseGuards)(nest_keycloak_connect_1.AuthGuard, nest_keycloak_connect_1.RoleGuard),
    __metadata("design:paramtypes", [dangerousgood_service_1.DangerousgoodService])
], DangerousgoodController);
exports.DangerousgoodController = DangerousgoodController;
//# sourceMappingURL=dangerousgood.controller.js.map