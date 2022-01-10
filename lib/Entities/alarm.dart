import 'package:json_annotation/json_annotation.dart';
part 'alarm.g.dart';

@JsonSerializable()
class Alarm{
  final int id;
  final String missionNumber;
  final String location;
  final DateTime timestamp;
  final int alertLevel;
  final String typeOfOperation;
  final String fireStation;

  Alarm(this.id, this.missionNumber, this.location, this.timestamp, this.alertLevel, this.typeOfOperation, this.fireStation);



  @override
  String toString() {
    return 'Alarm{_missionNumber: $missionNumber}';
  }

  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmToJson(this);
}