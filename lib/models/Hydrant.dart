import 'dart:ffi';

import 'package:flutter/material.dart';

class Hydrant{
  String? name;
  String? id;
  String? address;
  String? url;
  double? lng;
  double? lat;

  Hydrant(this.name, this.id, this.address ,this.lng, this.lat, this.url);
}