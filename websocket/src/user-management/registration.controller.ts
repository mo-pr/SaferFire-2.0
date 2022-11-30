import { Controller, Logger, Post, Body, HttpCode, HttpException, HttpStatus, } from '@nestjs/common';
import { Connection, ReturningStatementNotSupportedError } from 'typeorm';
import { UserRegistrationDto } from './Dtos';

@Controller('register')
export class RegistrationController {
    constructor(private conn:Connection){}
    private logger:Logger = new Logger('RegistrationController');

    @Post()
    @HttpCode(400)
    @HttpCode(201)
    async register(@Body() regUser:UserRegistrationDto){
        const qRunner = this.conn.createQueryRunner();
        await qRunner.connect();
        await qRunner.startTransaction();
        const r = await qRunner.query(`SELECT email,passwordhash,firestation FROM saferfireusers WHERE email LIKE '${regUser.email}' LIMIT 1`);
        if(r.length != 0){
            throw new HttpException('There is already a user with this email!', HttpStatus.BAD_REQUEST);
        }
        const res = await qRunner.query(`INSERT INTO saferfireusers (email,passwordhash,firestation) VALUES ('${regUser.email}','${regUser.passwordhash}','${regUser.firestation}')`);
        try{
            await qRunner.commitTransaction();
        }catch(err){
            await qRunner.rollbackTransaction();
            this.logger.log(`Unsuccessful registration | ${regUser.email}`);
            throw new HttpException('An error occured!',HttpStatus.BAD_REQUEST);
        }
        finally{
            await qRunner.release();
        }
        this.logger.log(`Successful registration | ${regUser.email}`);
        throw new HttpException('Registration successful!', HttpStatus.CREATED);
    }
}
