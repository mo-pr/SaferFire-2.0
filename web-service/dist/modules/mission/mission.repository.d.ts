import { DataSource, Repository } from "typeorm";
import { Mission } from "./mission.entity";
export declare class MissionRepository extends Repository<Mission> {
    private dataSource;
    constructor(dataSource: DataSource);
}
