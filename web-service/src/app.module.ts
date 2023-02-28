import { Module } from '@nestjs/common';
import { MissionModule } from './modules/mission/mission.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { typeOrmConfig } from './config/typeorm.config';
import { DangerousgoodModule } from './modules/dangerousgood/dangerousgood.module';

@Module({
  imports: [MissionModule, DangerousgoodModule,TypeOrmModule.forRoot(typeOrmConfig)],
  controllers: [],
  providers: [],
})
export class AppModule {}
