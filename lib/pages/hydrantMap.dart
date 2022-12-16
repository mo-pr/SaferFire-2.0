import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:saferfire/constants.dart';
import 'dart:convert';
import '../models/Hydrant.dart';

class HydrantMap extends StatelessWidget {
  HydrantMap({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Hydrantmap", home: StatefulHydrantWidget());
  }
}

class StatefulHydrantWidget extends StatefulWidget {
  const StatefulHydrantWidget({super.key});
  @override
  State<StatefulHydrantWidget> createState() => _StatefulHydrantWidgetState();
}

class _StatefulHydrantWidgetState extends State<StatefulHydrantWidget> {
  MapController controller = MapController(initMapWithUserPosition: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<Hydrant>>(
              future: loadMarkers(),
              builder: (BuildContext buildContext,
                  AsyncSnapshot<List<Hydrant>> snapshot) {
                return OSMFlutter(
                  controller: controller,
                  trackMyPosition: true,
                  initZoom: 15,
                  markerOption: MarkerOption(
                      defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 70,
                    ),
                  )),
                );
              }),
        ],
      ),
    );
  }

  Future<List<Hydrant>> loadMarkers() async {
    var currentPostion = await getCurrentPostion();
    var hydrants =
        await getHydrants(currentPostion.longitude, currentPostion.latitude);
    return await convertHydrantResponse(hydrants.body);
  }

  Future<Position> getCurrentPostion() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<http.Response> getHydrants(double lng, double lat) async {
    var gotHydrants = false;
    var response;
    var uri = Uri.parse(
        'https://api.wasserkarte.info/1.0/getSurroundingWaterSources/?source=$sourceAPI&token=$token&lat=${lat.toStringAsFixed(2)}&lng=${lng.toStringAsFixed(2)}&range=$range&numItems=$numItems');
    while(gotHydrants == false){
      try{
        response = await http.get(uri);
        gotHydrants = true;
      }catch(e){
        print(e);
      }
    }
    return response;
  }

  Future<List<Hydrant>> convertHydrantResponse(String response) async {
    Map<String, dynamic> hydrants = jsonDecode(response);
    var waterSources = hydrants['waterSources'];
    List<Hydrant> allHydrants = [];
    for (var singleWaterSource in waterSources) {
      var newHydrant = Hydrant(
          singleWaterSource['name'],
          singleWaterSource['id'].toString(),
          singleWaterSource['address'],
          singleWaterSource['longitude'],
          singleWaterSource['latitude'],
          singleWaterSource['iconUrl']);
      var myMarkerIcon =  const MarkerIcon(
          icon:  Icon(Icons.location_pin, color: Colors.blue, size: 150));
      await controller.addMarker(
           GeoPoint(latitude: newHydrant.lat!, longitude: newHydrant.lng!),
          markerIcon: myMarkerIcon);
    }
    return allHydrants;
  }
}
