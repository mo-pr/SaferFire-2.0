import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';

import 'alarm.dart';

List<Alarm> alarms = [];
Protocol protocol = new Protocol( null, null, null, null, null, null);
String ipAddress = "140.238.211.240";
bool isProtocol = false;
bool isTest = true;
Color buttonColor = Colors.red;