import 'package:saferfire/alarm.dart';

class Helper{
  List<Alarm> alarms = [];

  List<Alarm> GetAlarmsFromString(data){
    Alarm alarm = new Alarm(data);
    for(int i = 0; i < alarms.length; i++){
      if(alarms[i].Id == alarm.Id){
        return alarms;
      }
    }
    alarms.add(alarm);
    return alarms;
  }
}