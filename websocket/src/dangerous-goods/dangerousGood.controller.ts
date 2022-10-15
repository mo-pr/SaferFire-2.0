import { Body, Controller, HttpCode, HttpException, HttpStatus, Logger, Post } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { Connection} from "typeorm";
import { DangerousGoodsDto } from "./Dto";

@Controller('dangerousgoods')
export class DangerousGoodsController{
    constructor(private conn: Connection, private jwtService:JwtService) {}

    private logger:Logger = new Logger('DangerousController');

    @Post()
    @HttpCode(200)
    @HttpCode(400)
    @HttpCode(401)
    async dangerousGoods(@Body() payload:DangerousGoodsDto) {
        var dGood;
        if(this.jwtService.decode(payload.token)['user'] == "Admin"){
            try{
                dGood = await this.readDangerousGoodFromDatabase();
            }
            catch(err){
                throw new HttpException('Alarms could not be read from database',HttpStatus.BAD_REQUEST);
            }
            this.logger.log('Alarms read from database');
            return dGood;
        }
        else{
            throw new HttpException('Access denied',HttpStatus.UNAUTHORIZED);
        }
    }

    public async readDangerousGoodFromDatabase(){
        var goods
        this.logger.log("Reading substance from Database");
        const qRunner = this.conn.createQueryRunner();
        await qRunner.connect();
        await qRunner.query(`SELECT * FROM dangerousgoods`).then(x => goods=x);
        await qRunner.release();
        return goods;
    }
}