import { BaseEntity } from "typeorm";
export declare class Dangerousgood extends BaseEntity {
    un_nr: number;
    hazards_nr?: number;
    classification: string;
    name: string;
}
