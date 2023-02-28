import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DangerousgoodRepository } from './dangerousgood.repository';

@Injectable()
export class DangerousgoodService {
    constructor(@InjectRepository(DangerousgoodRepository) private dangerousgoodRepository: DangerousgoodRepository){}

    async getAllDangerousgoods(){
        return await this.dangerousgoodRepository.find();
    }
}
