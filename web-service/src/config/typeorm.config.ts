import { TypeOrmModuleOptions } from "@nestjs/typeorm";
import { Dangerousgood } from "src/modules/dangerousgood/dangerousgood.entity";
import { Mission } from "src/modules/mission/mission.entity";

export const typeOrmConfig: TypeOrmModuleOptions = {
    type: 'postgres',
    host: 'saferfire.org',
    port: 5432,
    username: 'dev',
    password: 'dev',
    database: 'saferfire',
    entities: [Mission,Dangerousgood],
    synchronize: false,
}