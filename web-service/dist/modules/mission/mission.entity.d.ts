import { BaseEntity } from "typeorm";
export declare class Mission extends BaseEntity {
    mission_id: string;
    alarm_time: string;
    stage: number;
    alarmtype: string;
    alarmsubtype: string;
    district?: string;
    street?: string;
    street_no?: number;
    area?: string;
    additional_info?: string;
    latitude: string;
    longitude: string;
    firedepartments: string;
}
