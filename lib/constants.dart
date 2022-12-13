import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'alarm.dart';

List<Protocol> protocols = <Protocol>[];
String ipAddress = "152.67.71.8";
bool isProtocol = false;
bool isTest = true;
int showingAlarmId = 0;
Color buttonColor = Colors.red;
List<Alarm> alarms = [];

MapController controller = MapController(
    initMapWithUserPosition: true
);

Color mainColor = Colors.red;

//Hydrant map
String source = "aic";
String token = "SBStE2gNllFTmvga";
String range = "10";
String numItems = "15";
