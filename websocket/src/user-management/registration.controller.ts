import { Controller, Logger, Post, Body, HttpCode, HttpException, HttpStatus, } from '@nestjs/common';
import { Connection, ReturningStatementNotSupportedError } from 'typeorm';
import { UserRegistrationDto } from './Dtos';

@Controller('registration')
export class RegistrationController {
    constructor(private conn:Connection){}
    private logger:Logger = new Logger('RegistrationController');

    @Post()
    @HttpCode(400)
    @HttpCode(201)
    async registration(@Body() regUser:UserRegistrationDto){
        const qRunner = this.conn.createQueryRunner();
        await qRunner.connect();
        await qRunner.startTransaction();
        const res = await qRunner.query(`INSERT INTO firefighters (email,passwordhash,firestation) VALUES ('${regUser.email}','${regUser.passwordhash}','${regUser.firestation}')`);
        try{
            await qRunner.commitTransaction();
        }catch(err){
            await qRunner.rollbackTransaction();
            throw new HttpException('An error occured!',HttpStatus.BAD_REQUEST);
        }
        finally{
            await qRunner.release();
        }
        throw new HttpException('Registration successful!', HttpStatus.CREATED);
    }
}
