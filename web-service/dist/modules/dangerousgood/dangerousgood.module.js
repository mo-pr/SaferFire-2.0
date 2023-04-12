"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DangerousgoodModule = void 0;
const common_1 = require("@nestjs/common");
const nest_keycloak_connect_1 = require("nest-keycloak-connect");
const core_1 = require("@nestjs/core");
const typeorm_1 = require("@nestjs/typeorm");
const dangerousgood_entity_1 = require("./dangerousgood.entity");
const dangerousgood_repository_1 = require("./dangerousgood.repository");
const dangerousgood_service_1 = require("./dangerousgood.service");
const dangerousgood_controller_1 = require("./dangerousgood.controller");
let DangerousgoodModule = class DangerousgoodModule {
};
DangerousgoodModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([dangerousgood_entity_1.Dangerousgood]), nest_keycloak_connect_1.KeycloakConnectModule.register({
                authServerUrl: 'https://saferfire.org:8443/',
                realm: 'saferfire',
                clientId: 'saferfire_app',
                secret: '21iLnw4dapoyDY8h0zcUs3GVCuqqCj7h',
                policyEnforcement: nest_keycloak_connect_1.PolicyEnforcementMode.PERMISSIVE,
                tokenValidation: nest_keycloak_connect_1.TokenValidation.ONLINE,
            }),],
        controllers: [dangerousgood_controller_1.DangerousgoodController],
        providers: [dangerousgood_service_1.DangerousgoodService, dangerousgood_repository_1.DangerousgoodRepository,
            {
                provide: core_1.APP_GUARD,
                useClass: nest_keycloak_connect_1.AuthGuard,
            },
            {
                provide: core_1.APP_GUARD,
                useClass: nest_keycloak_connect_1.ResourceGuard,
            },
            {
                provide: core_1.APP_GUARD,
                useClass: nest_keycloak_connect_1.RoleGuard,
            },]
    })
], DangerousgoodModule);
exports.DangerousgoodModule = DangerousgoodModule;
//# sourceMappingURL=dangerousgood.module.js.map