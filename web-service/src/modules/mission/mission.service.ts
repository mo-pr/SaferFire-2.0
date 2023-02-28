import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { MissionRepository } from './mission.repository';
import { Mission } from './mission.dto';
import { Like } from 'typeorm';

@Injectable()
export class MissionService {
    constructor(@InjectRepository(MissionRepository) private missionRepository: MissionRepository){}

    async getMissionsByDepartment(department:string){
        return await this.missionRepository.find({
            where: {
                firedepartments: Like(`%${department}%`)
            }
        });
    }

    async saveMission(mission:Mission){
        await this.missionRepository.save(mission);
        return
    }
}
