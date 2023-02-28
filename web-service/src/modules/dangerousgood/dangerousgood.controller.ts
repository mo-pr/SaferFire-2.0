import { Body, Controller, Get, HttpCode, HttpException, HttpStatus, Logger, Post, UseGuards } from '@nestjs/common';
import { Roles,AuthGuard, RoleGuard, RoleMatchingMode } from 'nest-keycloak-connect';
import { DangerousgoodService } from './dangerousgood.service';

@Controller('dangerousgood')
@UseGuards(AuthGuard, RoleGuard)
export class DangerousgoodController {
    constructor(private dangerousgoodService: DangerousgoodService){}

    private logger:Logger = new Logger('DangerousgoodController');

    @Get('/getall')
    @HttpCode(200)
    @Roles({roles:['dev_admin','saferfire_admin','saferfire_kommando','saferfire_mannschaft'],mode:RoleMatchingMode.ANY})
    async getAll(){
        let dangerousgoods = await this.dangerousgoodService.getAllDangerousgoods();
        this.logger.log('Dangerousgoods successfully read from database.')
        return dangerousgoods;
    }
}
