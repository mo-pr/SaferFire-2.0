import { Body, Controller, HttpCode, HttpException, HttpStatus, Logger, Post } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { Connection } from "typeorm";
import "./alarms.gateway";
import { AlarmsGateway } from "./alarms.gateway";

@Controller('alarmdb')
export class AlarmDBController {
    constructor(private conn: Connection, private jwtService:JwtService) {}

    private logger:Logger = new Logger('AlarmDBController');

    @Post()
    @HttpCode(200)
    @HttpCode(400)
    @HttpCode(401)
    async alarmdb(@Body() token:string) {
        if(this.jwtService.decode(token['token'])['user'] == "Admin"){
            let ag  = new AlarmsGateway(this.conn,this.jwtService);
            try{
                ag.writeAlarmsToDatabase();
            }
            catch(err){
                throw new HttpException('Alarms could not be written to database',HttpStatus.BAD_REQUEST);
            }
            this.logger.log('Alarms written to database');
            throw new HttpException('Alarms successfully written to database',HttpStatus.OK);
        }
        else{
            throw new HttpException('Access denied',HttpStatus.UNAUTHORIZED);
        }
    }
}
