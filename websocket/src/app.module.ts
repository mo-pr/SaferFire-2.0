import { Module } from '@nestjs/common';
import { AlarmsGateway } from './alarms/alarms.gateway';
import { LoginController } from './user-management/login.controller';
import { TypeOrmModule } from "@nestjs/typeorm";
import { PassportModule } from '@nestjs/passport';
import { dbConstants, jwtConstants } from './constants';
import { JwtModule } from '@nestjs/jwt';
import { RegistrationController } from './user-management/registration.controller';
import { TestGateway } from './testing/test.gateway';
import { GuestController } from './user-management/guest.controller';
import { ScheduleModule } from '@nestjs/schedule';
import { AlarmDBController,AllAlarmsDBController } from './alarms/alarmdb.controller';
import { AllAlarmsGateway } from './alarms/allAlarms.gateway';
import { DangerousGoodsController } from './dangerous-goods/dangerousGood.controller';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: dbConstants.host,
      port: dbConstants.port,
      username: dbConstants.username,
      password: dbConstants.password,
      database: dbConstants.database,
      entities: [],
      synchronize: true,
    }),
    PassportModule,
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: {expiresIn: '365d'}
    }),
  ],
  controllers: [LoginController, RegistrationController, GuestController, AlarmDBController,AllAlarmsDBController,DangerousGoodsController],
  providers: [AlarmsGateway, TestGateway,AllAlarmsGateway],
})
export class AppModule {}
