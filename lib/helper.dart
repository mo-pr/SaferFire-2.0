import 'package:saferfire/alarm.dart';

class Helper{
  List<Alarm> GetAlarmsFromString(data){
    List<Alarm> alarms = [];
    int count = data['cnt_einsaetze'];
    for(int i = 0; i < count;i++){
      alarms.add(new Alarm(data['einsaetze'][i.toString()]['einsatz']));
    }
    return alarms;
  }
}