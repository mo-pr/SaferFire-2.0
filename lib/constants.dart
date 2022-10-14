import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';

import 'alarm.dart';

Protocol protocol = Protocol(null, null, null, null, null, null);
String ipAddress = "152.67.71.8";
bool isProtocol = false;
bool isTest = true;
Color mainColor = const Color(0xFFbb1e10);
Color buttonColor = Colors.red;
List<Alarm> alarms = [];
