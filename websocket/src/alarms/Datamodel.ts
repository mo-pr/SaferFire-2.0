export class Mission {
  id:String;
  time:Date;
  stage:Number;
  alarmType:String;
  alarmsubtype:String;
  district:String;
  street:String;
  street_no:String;
  area:String;
  additional_info:String;
  longitude:String;
  latitude:String;
  firedepartments:String;
  Mission(ID:String,TIME:Date,STAGE:Number,TYPE:String,SUBTYPE:String,DISTRICT:String,STREET:String,STREETNO:String,AREA:String,ADD_INFO:String,LNG:String,LAT:String,FIREDEPS:String){
    this.id = ID;
    this.time = TIME;
    this.stage = STAGE;
    this.alarmType = TYPE;
    this.alarmsubtype = SUBTYPE;
    this.district = DISTRICT;
    this.street = STREET;
    this.street_no = STREETNO;
    this.area = AREA;
    this.additional_info = ADD_INFO;
    this.longitude = LNG;
    this.latitude = LAT;
    this.firedepartments = FIREDEPS;
  }
}
export class AlarmsDBUser{
  token:string;
  firestation:string;
}