import { Body, Controller, HttpCode, HttpException, HttpStatus, Logger, Post } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { Connection } from "typeorm";
import { GuestRegistrationDto } from "./Dtos";

@Controller('guest')
export class GuestController {
    constructor(private conn: Connection, private jwtService:JwtService) {}

    private logger:Logger = new Logger('GuestController');

    @Post()
    @HttpCode(200)
    @HttpCode(400)
    async login(@Body() guestUser: GuestRegistrationDto) {
        console.log(guestUser);
        const qRunner = this.conn.createQueryRunner();
        await qRunner.connect();
        await qRunner.startTransaction();
        const res = await qRunner.query(`INSERT INTO guestuser (firestation) VALUES ('${guestUser.firestation}')`);
        try{
            await qRunner.commitTransaction();
        }catch(err){
            await qRunner.rollbackTransaction();
            this.logger.log(`Unsuccessful Guest | ${guestUser.firestation}`);
            throw new HttpException('An error occured!',HttpStatus.BAD_REQUEST);
        }
        finally{
            await qRunner.release();
        }
        const payload = {firestation:guestUser.firestation}
        const access_token = await this.jwtService.signAsync(payload)
        await qRunner.release();
        this.logger.log(`Successful Guest | ${guestUser.firestation}`)
        return access_token;
    }
}