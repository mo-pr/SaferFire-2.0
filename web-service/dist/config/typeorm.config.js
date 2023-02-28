"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.typeOrmConfig = void 0;
const dangerousgood_entity_1 = require("../modules/dangerousgood/dangerousgood.entity");
const mission_entity_1 = require("../modules/mission/mission.entity");
exports.typeOrmConfig = {
    type: 'postgres',
    host: 'saferfire.org',
    port: 5432,
    username: 'dev',
    password: 'dev',
    database: 'saferfire',
    entities: [mission_entity_1.Mission, dangerousgood_entity_1.Dangerousgood],
    synchronize: false,
};
//# sourceMappingURL=typeorm.config.js.map