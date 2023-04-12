import { Mission } from "./mission.dto";
export declare class MissionHelper {
    getAlarms(needCurrent: boolean): Promise<any>;
    extractAlarms(): Promise<Mission[]>;
}
