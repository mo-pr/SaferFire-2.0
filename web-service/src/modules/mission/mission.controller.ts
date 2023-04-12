import { Body, Controller, Get, HttpCode, HttpException, HttpStatus, Logger, Post, UseGuards } from '@nestjs/common';
import { MissionService } from './mission.service';
import { MissionHelper } from './mission.helper';
import { FiredepartmentBody } from './mission.dto';
import { Roles,AuthGuard, RoleGuard, RoleMatchingMode } from 'nest-keycloak-connect';

@Controller('mission')
//@UseGuards(AuthGuard, RoleGuard)
export class MissionController {
    constructor(private missionService: MissionService){}

    private logger:Logger = new Logger('MissionController');

    @Get('/writemissions')
    //@Roles({roles:['dev_admin']})
    async writeAllAlarms(){
        let helper = new MissionHelper()
        let missions = await helper.extractAlarms()
        try{
            missions.forEach(async (mission) => await this.missionService.saveMission(mission))
        }
        catch(error){
            this.logger.error("Error writing missions to database"+error.message)
            throw new HttpException('Missions could not be written to database!',HttpStatus.BAD_REQUEST);
        }
        this.logger.log("Missions written to database")
        throw new HttpException('Missions successfully written to database.',HttpStatus.OK);
    }

    @Post('/getbyfiredepartment')
    @HttpCode(200)
    //@Roles({roles:['dev_admin','saferfire_admin','saferfire_kommando','saferfire_mannschaft'],mode:RoleMatchingMode.ANY})
    async getByfiredepartment(@Body() payload:FiredepartmentBody){
        if(payload.firedepartment == null || payload.firedepartment == ""){
            throw new HttpException('Firedepartment is a required input!',HttpStatus.BAD_REQUEST);
        }
        let missions = await this.missionService.getMissionsByDepartment(payload.firedepartment)
        this.logger.log('Missions successfully read from database.')
        return missions
    }
}
