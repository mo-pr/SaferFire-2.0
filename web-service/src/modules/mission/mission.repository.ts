import { DataSource, EntityRepository, Repository } from "typeorm"
import { Mission } from "./mission.entity"
import { Injectable } from "@nestjs/common";

@Injectable()
export class MissionRepository extends Repository<Mission> {
    constructor(private dataSource: DataSource) {
        super(Mission, dataSource.createEntityManager());
    }
}