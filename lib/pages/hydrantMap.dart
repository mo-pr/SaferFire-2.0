import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:saferfire/constants.dart';
import 'dart:convert';


import '../models/Hydrant.dart';


class HydrantMap extends StatelessWidget {
  HydrantMap({Key? key}) : super(key: key);
  MapController controller = MapController(
      initMapWithUserPosition: true
  );

  Widget build(BuildContext context) {
    var response = getCurrentPosition().then((value) =>  getHydrants(value.longitude, value.latitude)).then((value) => convertHydrantResponse(value.body));
    return OSMFlutter(
      controller:controller,
      trackMyPosition: true,
      initZoom: 15,
      markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 70,
            ),
          )
      ),
    );
  }

  Future<Position> getCurrentPosition() async{
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<http.Response> getHydrants(double lng, double lat) async{
    return http.get(
      Uri.parse('https://api.wasserkarte.info/1.0/getSurroundingWaterSources/?source=$source&token=$token&lat=$lat&lng=$lng&range=$range&numItems=$numItems'),
    );
  }
  Future<List<Hydrant>> convertHydrantResponse(String response) async{
    Map<String, dynamic> hydrants = jsonDecode(response);
    var waterSources = hydrants['waterSources'];
    List<Hydrant> allHydrants = [];
    for(var singleWaterSource in waterSources){
     var newHydrant = Hydrant(singleWaterSource['name'], singleWaterSource['id'].toString(), singleWaterSource['address'], singleWaterSource['longitude'], singleWaterSource['latitude']);
     allHydrants.add(newHydrant);
     var markerIcon = const MarkerIcon(icon: Icon(Icons.fire_hydrant,color: Colors.blue,size:200));
     await controller.addMarker(GeoPoint(latitude: newHydrant.lat!, longitude: newHydrant.lng!), markerIcon:  markerIcon);
    }
    return allHydrants;
  }
}
