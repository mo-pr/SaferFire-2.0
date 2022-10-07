import { Body, Controller, HttpCode, HttpException, HttpStatus, Logger, Post } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { Connection, createQueryBuilder } from "typeorm";
import "./alarms.gateway";
import { AlarmsGateway } from "./alarms.gateway";
import { AlarmsDBUser } from "./Datamodel";

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
@Controller('allalarmsdb')
export class AllAlarmsDBController{
    constructor(private conn: Connection, private jwtService:JwtService) {}

    private logger:Logger = new Logger('AllAlarmsDBController');

    @Post()
    @HttpCode(200)
    @HttpCode(400)
    @HttpCode(401)
    async allalarmsdb(@Body() payload:AlarmsDBUser) {
        var alarms;
        if(this.jwtService.decode(payload.token)['user'] == "Admin"){
            let ag  = new AlarmsGateway(this.conn,this.jwtService);
            try{
                alarms = this.readAlarmsFromDatabase(payload.firestation);
            }
            catch(err){
                throw new HttpException('Alarms could not be read from database',HttpStatus.BAD_REQUEST);
            }
            this.logger.log('Alarms read from database');
            throw new HttpException(alarms,HttpStatus.OK);
        }
        else{
            throw new HttpException('Access denied',HttpStatus.UNAUTHORIZED);
        }
    }

    public async readAlarmsFromDatabase(firestation:string){
        var alarms
        this.logger.log("Reading Alarms from Database");
        const qRunner = this.conn.createQueryRunner();
        await qRunner.connect();
        await qRunner.query(`SELECT * FROM missiondata WHERE firedepartments LIKE '%${firestation}%'`).then(x => alarms=x);
        await qRunner.release();
        return alarms;
    }
}
