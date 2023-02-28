import { BaseEntity, Column, Entity, PrimaryColumn } from "typeorm";

@Entity('missiondata')
export class Mission extends BaseEntity{
    @PrimaryColumn({type: 'varchar', length: 10, nullable: false})
    mission_id: string;

    @Column({type: 'varchar', length: 100, nullable: false})
    alarm_time: string;

    @Column({type: 'numeric', nullable:false})
    stage: number;

    @Column({type: 'varchar', length: 100, nullable: false})
    alarmtype: string;

    @Column({type: 'varchar', length: 100, nullable:false})
    alarmsubtype: string;

    @Column({type: 'varchar', length: 100,nullable: true})
    district?: string;

    @Column({type: 'varchar', length: 100,nullable: true})
    street?: string;

    @Column({type: 'numeric', nullable: true})
    street_no?: number;

    @Column({type: 'varchar', length: 100,nullable: true})
    area?: string;

    @Column({type: 'varchar', length: 100,nullable: true})
    additional_info?: string;

    @Column({type: 'varchar', length: 15, nullable:false})
    latitude: string;

    @Column({type: 'varchar', length: 15, nullable:false})
    longitude: string;

    @Column({type: 'varchar', length: 250, nullable:false})
    firedepartments: string;
}