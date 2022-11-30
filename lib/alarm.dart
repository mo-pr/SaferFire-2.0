class Alarm {
  String? _Id;
  String? _Time;
  String? _Stage;
  String? _AlarmType;
  String? _Type;
  String? _Subtype;
  String? _Address;
  double _Lat=0.0;
  double _Lng=0.0;
  String? _District;
  List<String>? _FireDeps;

  Alarm(alarmBody){
    this.Id = alarmBody['num1'];
    this.Time = alarmBody['startzeit'];
    this.Stage = alarmBody['alarmstufe'].toString();
    this.AlarmType = alarmBody['einsatzart'];
    this.Type = alarmBody['einsatztyp']['text'];
    this.Subtype = alarmBody['einsatzsubtyp']['text'];
    this.Address = alarmBody['adresse']['default']??'' + ", " + alarmBody['adresse']['earea']??'' + "\nZusatz: " + alarmBody['adresse']['ecompl']??'';
    this.Lat = alarmBody['wgs84']['lat'];
    this.Lng = alarmBody['wgs84']['lng'];
    this.District = alarmBody['bezirk']['text'];
    List<String> firedeps = [];
    for(int i = 0; i < alarmBody['cntfeuerwehren'];i++){
      firedeps.add(alarmBody['feuerwehrenarray'][i.toString()]['fwname']+"\n");
    }
    this.FireDeps = firedeps;
  }



  factory Alarm.fromJson(Map<String, dynamic> parsedJson){
    var alarm = new Alarm("");
    alarm.Id = parsedJson['num1'];
    alarm.Time=parsedJson['startzeit'];
    alarm.Stage = parsedJson['alarmstufe'].toString();
    alarm.AlarmType = parsedJson['einsatzart'];
    alarm.Type = parsedJson['einsatztyp']['text'];
    alarm.Subtype = parsedJson['einsatzsubtyp']['text'];
    alarm.Address = parsedJson['adresse']['default']??'' + ", " + parsedJson['adresse']['earea']??'' + "\nZusatz: " + parsedJson['adresse']['ecompl']??'';
    alarm.Lat = parsedJson['wgs84']['lat'];
    alarm.Lng = parsedJson['wgs84']['lng'];
    alarm.District = parsedJson['bezirk']['text'];
    List<String> firedeps = [];
    for(int i = 0; i < parsedJson['cntfeuerwehren'];i++){
      firedeps.add(parsedJson['feuerwehrenarray'][i.toString()]['fwname']+"\n");
    }
    alarm.FireDeps = firedeps;
    return alarm;
  }

  @override
  String toString() {
    return 'Alarm{Id: $_Id, Time: $_Time, Stage: $_Stage, AlarmType: $_AlarmType, Type: $_Type, Subtype: $_Subtype, Address: $_Address, Lat: $_Lat, Lng: $_Lng, District: $_District, FireDeps: $_FireDeps}';
  } //region Getter & Setter
  List<String>? get FireDeps => _FireDeps;

  set FireDeps(List<String>? value) {
    _FireDeps = value;
  }

  String? get District => _District;

  set District(String? value) {
    _District = value;
  }

  double get Lng => _Lng;

  set Lng(double value) {
    _Lng = value;
  }

  double get Lat => _Lat;

  set Lat(double value) {
    _Lat = value;
  }

  String? get Address => _Address;

  set Address(String? value) {
    _Address = value;
  }

  String? get Subtype => _Subtype;

  set Subtype(String? value) {
    _Subtype = value;
  }

  String? get Type => _Type;

  set Type(String? value) {
    _Type = value;
  }

  String? get AlarmType => _AlarmType;

  set AlarmType(String? value) {
    _AlarmType = value;
  }

  String? get Stage => _Stage;

  set Stage(String? value) {
    _Stage = value;
  }

  String? get Time => _Time;

  set Time(String? value) {
    _Time = value;
  }

  String? get Id => _Id;

  set Id(String? value) {
    _Id = value;
  }
  //endregion
}