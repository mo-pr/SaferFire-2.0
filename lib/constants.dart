import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';

import 'alarm.dart';

List<Alarm> alarms = [];
Protocol protocol = new Protocol(null, null, null, null, null);
String ipAddress = "152.67.71.8";
bool isProtocol = false;
bool isTest = true;
