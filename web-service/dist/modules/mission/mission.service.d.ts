import { MissionRepository } from './mission.repository';
import { Mission } from './mission.dto';
export declare class MissionService {
    private missionRepository;
    constructor(missionRepository: MissionRepository);
    getMissionsByDepartment(department: string): Promise<import("./mission.entity").Mission[]>;
    saveMission(mission: Mission): Promise<void>;
}
