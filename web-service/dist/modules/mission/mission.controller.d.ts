import { MissionService } from './mission.service';
import { FiredepartmentBody } from './mission.dto';
export declare class MissionController {
    private missionService;
    constructor(missionService: MissionService);
    private logger;
    writeAllAlarms(): Promise<void>;
    getByfiredepartment(payload: FiredepartmentBody): Promise<import("./mission.entity").Mission[]>;
}
