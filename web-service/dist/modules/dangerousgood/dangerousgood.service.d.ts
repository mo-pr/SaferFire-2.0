import { DangerousgoodRepository } from './dangerousgood.repository';
export declare class DangerousgoodService {
    private dangerousgoodRepository;
    constructor(dangerousgoodRepository: DangerousgoodRepository);
    getAllDangerousgoods(): Promise<import("./dangerousgood.entity").Dangerousgood[]>;
}
