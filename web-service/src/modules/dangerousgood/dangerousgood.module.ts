import { Module } from '@nestjs/common';
import { AuthGuard, KeycloakConnectModule, PolicyEnforcementMode, ResourceGuard, RoleGuard, TokenValidation } from 'nest-keycloak-connect';
import { APP_GUARD } from '@nestjs/core';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Dangerousgood } from './dangerousgood.entity';
import { DangerousgoodRepository } from './dangerousgood.repository';
import { DangerousgoodService } from './dangerousgood.service';
import { DangerousgoodController } from './dangerousgood.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Dangerousgood]), KeycloakConnectModule.register({
    authServerUrl: 'https://saferfire.org:8443/',
    realm: 'saferfire',
    clientId: 'saferfire_app',
    secret: '21iLnw4dapoyDY8h0zcUs3GVCuqqCj7h',
    policyEnforcement: PolicyEnforcementMode.PERMISSIVE,
    tokenValidation: TokenValidation.ONLINE,
  }),],
  controllers: [DangerousgoodController],
  providers: [DangerousgoodService, DangerousgoodRepository,
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
export class DangerousgoodModule {}
