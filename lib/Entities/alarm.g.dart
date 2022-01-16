// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alarm _$AlarmFromJson(Map<String, dynamic> json) => Alarm(
      json['id'] as int,
      json['missionNumber'] as String,
      json['location'] as String,
      DateTime.parse(json['timestamp'] as String),
      json['alertLevel'] as int,
      json['typeOfOperation'] as String,
      json['fireStation'] as String,
    );

Map<String, dynamic> _$AlarmToJson(Alarm instance) => <String, dynamic>{
      'id': instance.id,
      'missionNumber': instance.missionNumber,
      'location': instance.location,
      'timestamp': instance.timestamp.toIso8601String(),
      'alertLevel': instance.alertLevel,
      'typeOfOperation': instance.typeOfOperation,
      'fireStation': instance.fireStation,
    };
