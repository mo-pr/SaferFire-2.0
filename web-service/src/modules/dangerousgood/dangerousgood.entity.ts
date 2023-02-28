import { BaseEntity, Column, Entity, PrimaryColumn } from "typeorm";

@Entity('dangerousgoods')
export class Dangerousgood extends BaseEntity{
    @PrimaryColumn({type: 'numeric', nullable: false})
    un_nr: number;

    @Column({type: 'numeric', nullable: true})
    hazards_nr?: number;

    @Column({type: 'varchar', nullable:false})
    classification: string;

    @Column({type: 'varchar', nullable: false})
    name: string;
}