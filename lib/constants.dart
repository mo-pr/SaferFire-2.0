import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';

import 'alarm.dart';

List<Alarm> alarms = [];
Color buttonColor = Color(0xeFFB82626);
Protocol protocol = new Protocol(null, null, null, null, null, null);
bool isProtocol = false;
String ipAddress = "140.238.211.240";
bool isTest = true;
