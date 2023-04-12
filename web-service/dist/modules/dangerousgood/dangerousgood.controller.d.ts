import { DangerousgoodService } from './dangerousgood.service';
export declare class DangerousgoodController {
    private dangerousgoodService;
    constructor(dangerousgoodService: DangerousgoodService);
    private logger;
    getAll(): Promise<import("./dangerousgood.entity").Dangerousgood[]>;
}
