import 'package:saferfire/alarm.dart';

class Helper{
  List<Alarm> GetAlarmsFromString(data){
    List<Alarm> alarms = [];
    alarms.add(new Alarm(data));
    return alarms;
  }
}