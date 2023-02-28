import { IsNotEmpty } from 'class-validator';

export class Mission {
  @IsNotEmpty()
  mission_id:string;

  @IsNotEmpty()
  alarm_time:string;

  @IsNotEmpty()
  stage:number;

  @IsNotEmpty()
  alarmtype:string;

  @IsNotEmpty()
  alarmsubtype:string;

  district:string;
  street:string;
  street_no:number;
  area:string;
  additional_info:string;

  @IsNotEmpty()
  longitude:string;

  @IsNotEmpty()
  latitude:string;

  @IsNotEmpty()
  firedepartments:string;
}

export class FiredepartmentBody{
  firedepartment:string
}