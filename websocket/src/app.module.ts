import { Module } from '@nestjs/common';
import { AlarmsGateway } from './alarms/alarms.gateway';

@Module({
  imports: [],
  controllers: [],
  providers: [AlarmsGateway],
})
export class AppModule {}
