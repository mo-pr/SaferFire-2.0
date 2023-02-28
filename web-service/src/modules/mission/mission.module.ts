import { Module } from '@nestjs/common';
import { MissionController } from './mission.controller';
import { MissionService } from './mission.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MissionRepository } from './mission.repository';
import { Mission } from './mission.entity';
import { AuthGuard, KeycloakConnectModule, PolicyEnforcementMode, ResourceGuard, RoleGuard, TokenValidation } from 'nest-keycloak-connect';
import { APP_GUARD } from '@nestjs/core';
import { MissionGateway } from './mission.gateway';
import { MissionTestGateway } from './mission.testgateway';

@Module({
  imports: [TypeOrmModule.forFeature([Mission]), KeycloakConnectModule.register({
    authServerUrl: 'https://saferfire.org:8443/',
    realm: 'saferfire',
    clientId: 'saferfire_app',
    secret: '21iLnw4dapoyDY8h0zcUs3GVCuqqCj7h',
    policyEnforcement: PolicyEnforcementMode.PERMISSIVE,
    tokenValidation: TokenValidation.ONLINE,
  }),],
  controllers: [MissionController],
  providers: [MissionService, MissionRepository, MissionGateway, MissionTestGateway,
  {
    provide: APP_GUARD,
    useClass: AuthGuard,
  },
  {
    provide: APP_GUARD,
    useClass: ResourceGuard,
  },
  {
    provide: APP_GUARD,
    useClass: RoleGuard,
  },]
})
export class MissionModule {}
