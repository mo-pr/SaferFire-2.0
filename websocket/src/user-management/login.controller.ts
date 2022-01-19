import { Controller, Post, Body, HttpCode, HttpException, HttpStatus, Logger } from '@nestjs/common';
import { UserLoginDto } from './Dtos'
import { Connection } from "typeorm";
import { JwtService } from '@nestjs/jwt';

@Controller('login')
export class LoginController {
    constructor(private conn: Connection, private jwtService:JwtService) {}

    private logger:Logger = new Logger('LoginController');

    @Post()
    @HttpCode(200)
    @HttpCode(400)
    async login(@Body() loginUser: UserLoginDto) {
        const qRunner = this.conn.createQueryRunner();
        await qRunner.connect();
        const res = await qRunner.query(`SELECT email,passwordhash,firestation FROM firefighters WHERE email LIKE '${loginUser.email}' LIMIT 1`);
        if(res.length === 0){
            this.logger.log(`Unsuccessful login | ${loginUser.email}`)
            throw new HttpException('Email or password incorrect!', HttpStatus.BAD_REQUEST);
        }
        if(loginUser.passwordhash != res[0]['passwordhash']){
            this.logger.log(`Unsuccessful login | ${loginUser.email}`)
            throw new HttpException('Email or password incorrect!', HttpStatus.BAD_REQUEST);
        }
        const payload = {email:loginUser.email,firestation:res[0]['firestation']}
        const access_token = await this.jwtService.signAsync(payload)
        await qRunner.release();
        this.logger.log(`Successful login | ${loginUser.email}`)
        return access_token;
    }
}
