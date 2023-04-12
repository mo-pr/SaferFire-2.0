import { DataSource, Repository } from "typeorm";
import { Dangerousgood } from "./dangerousgood.entity";
export declare class DangerousgoodRepository extends Repository<Dangerousgood> {
    private dataSource;
    constructor(dataSource: DataSource);
}
