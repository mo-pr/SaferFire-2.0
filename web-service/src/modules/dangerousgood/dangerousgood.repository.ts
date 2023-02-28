import { DataSource, EntityRepository, Repository } from "typeorm"
import { Injectable } from "@nestjs/common";
import { Dangerousgood } from "./dangerousgood.entity";

@Injectable()
export class DangerousgoodRepository extends Repository<Dangerousgood> {
    constructor(private dataSource: DataSource) {
        super(Dangerousgood, dataSource.createEntityManager());
    }
}