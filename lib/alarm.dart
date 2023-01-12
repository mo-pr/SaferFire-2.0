class Alarm {
  String? id;
  String? time;
  String? stage;
  String? alarmType;
  String? type;
  String? subtype;
  String? address;
  double lat=0.0;
  double lng=0.0;
  String? district;
  List<String>? fireDeps;

  Alarm(alarmBody){
    id = alarmBody['num1'];
    time = alarmBody['startzeit'];
    stage = alarmBody['alarmstufe'].toString();
    alarmType = alarmBody['einsatzart'];
    type = alarmBody['einsatztyp']['text'];
    subtype = alarmBody['einsatzsubtyp']['text'];
    address = alarmBody['adresse']['default']??'' + ", " + alarmBody['adresse']['earea']??'' + "\nZusatz: " + alarmBody['adresse']['ecompl']??'';
    lat = alarmBody['wgs84']['lat'];
    lng = alarmBody['wgs84']['lng'];
    district = alarmBody['bezirk']['text'];
    List<String> firedeps = [];
    for(int i = 0; i < alarmBody['cntfeuerwehren'];i++){
      firedeps.add(alarmBody['feuerwehrenarray'][i.toString()]['fwname']+"\n");
    }
    fireDeps = firedeps;
  }



  factory Alarm.fromJson(Map<String, dynamic> parsedJson){
    var alarm = new Alarm("");
    alarm.id = parsedJson['num1'];
    alarm.time=parsedJson['startzeit'];
    alarm.stage = parsedJson['alarmstufe'].toString();
    alarm.alarmType = parsedJson['einsatzart'];
    alarm.type = parsedJson['einsatztyp']['text'];
    alarm.subtype = parsedJson['einsatzsubtyp']['text'];
    alarm.address = parsedJson['adresse']['default']??'' + ", " + parsedJson['adresse']['earea']??'' + "\nZusatz: " + parsedJson['adresse']['ecompl']??'';
    alarm.lat = parsedJson['wgs84']['lat'];
    alarm.lng = parsedJson['wgs84']['lng'];
    alarm.district = parsedJson['bezirk']['text'];
    List<String> firedeps = [];
    for(int i = 0; i < parsedJson['cntfeuerwehren'];i++){
      firedeps.add(parsedJson['feuerwehrenarray'][i.toString()]['fwname']+"\n");
    }
    alarm.fireDeps = firedeps;
    return alarm;
  }

  @override
  String toString() {
    return 'Alarm{Id: $id, Time: $time, Stage: $stage, AlarmType: $alarmType, Type: $type, Subtype: $subtype, Address: $address, Lat: $lat, Lng: $lng, District: $district, FireDeps: $fireDeps}';
  }

}