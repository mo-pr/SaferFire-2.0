import { Module } from '@nestjs/common';
import { AlarmsGateway } from './alarms/alarms.gateway';
import { UserManagementController } from './user-management/login.controller';
import { TypeOrmModule } from "@nestjs/typeorm";
import { PassportModule } from '@nestjs/passport';
import { dbConstants, jwtConstants } from './constants';
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
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
  controllers: [UserManagementController],
  providers: [AlarmsGateway],
})
export class AppModule {}
