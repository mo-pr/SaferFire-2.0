import 'dart:async';
import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:saferfire/pages/hydrantMap.dart';
import 'package:saferfire/pages/linechart.dart';
import 'package:saferfire/notificationservice.dart';
import 'package:saferfire/pages/oxygentool_page.dart';
import 'package:saferfire/pages/protocoltool_page.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:saferfire/alarm.dart';
import 'package:saferfire/constants.dart' as cons;
import 'package:saferfire/loginPage.dart';
import 'package:saferfire/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:saferfire/models/Protocol.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

var _cardColor = Colors.white;
const _openNavbarColor = Color(0xFFbb1e10);
const _backgroundColor = Colors.white;
const _maxHeight = 350.0;
const _minHeight = 70.0;
List _allDeployments = [];
bool _isGuest = false;
bool _isDeployment = false;

String _alarmId = " ";
String _alarmSubtype = " ";
String _alarmAdress = " ";
String _alarmLat = " ";
String _alarmFireDepts = " ";
String _alarmTime = " ";
late Socket socket;

late AnimationController _animationController;
late Animation _animation;

//String _timeString = "";
PageController _pageController = PageController(initialPage: 0);

changeAlarm (int newAlarmId){
  cons.showingAlarmId = newAlarmId;
}


class Start extends StatefulWidget {
  @override
  StartPage createState() => StartPage();
}

class StartPage extends State<Start> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  Future<void> _websocketReq() async {
    var prefs = await SharedPreferences.getInstance();
    if  (cons.isTest)  {
      socket.emit('alarmsReq',
          json.encode({'token': prefs.getString('token'), "count": 4}));
    }
    if (!cons.isTest) {
      socket.emit(
          'alarmsReq', json.encode({'token': prefs.getString('token')}));
    }
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }


  // Map
  /*
  Future<Position> getCurrentPosition() async{
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<http.Response> getHydrants(double lng, double lat) async{
    return http.get(
      Uri.parse('https://api.wasserkarte.info/1.0/getSurroundingWaterSources/?source=${cons.source}&token=${cons.token}&lat=$lat&lng=$lng&range=${cons.range}&numItems=${cons.numItems}'),
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
      await cons.controller.addMarker(GeoPoint(latitude: newHydrant.lat!, longitude: newHydrant.lng!), markerIcon:  markerIcon);
    }
    return allHydrants;
  }*/

  @override
  void initState() {
    _animationController = AnimationController(vsync:this,duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation =  Tween(begin: 8.0,end: 12.0).animate(_animationController)..addListener((){
      setState(() {

      });
    });
    setState(() {
      _getSharedPreference().then((value) => _isGuest = value);
    });
    if (cons.isTest) {
      socket = io('http://${cons.ipAddress}/testalarms', <String, dynamic>{
        'transports': ['websocket'],
        'forceNew': true
      });
    }
    if (!cons.isTest) {
      socket = io('http://${cons.ipAddress}/alarms', <String, dynamic>{
        'transports': ['websocket'],
        'forceNew': true
      });
    }
    socket.connect();
    _websocketReq();
    socket.on('alarmsRes', (data) async {
      print(data);
      Alarm alarm = new Alarm(data);
      for (int i = 0; i < cons.alarms.length; i++) {
        if (cons.alarms[i].Id == alarm.Id) {
          return cons.alarms;
        }
      }
      cons.alarms.add(alarm);
      //If you get alarm for your firestation, get push notification
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var firestation = prefs.getString('firestation');
      if (alarm.FireDeps.toString()
          .contains(firestation!)) //if alarm is for your firestation
      {
        NotificationService().showNotification(
            0,
            "Neuer Einsatz!",
            "${alarm.Subtype}, ${alarm.Address}",
            2); //you get a push notification
      }

      return cons.alarms;
    });
    socket.on(
        'connect_error', (data) => print("ConnErr: " + data)); //debug output
    socket.on('error', (data) => print("Err: " + data));
    Timer.periodic(
        const Duration(seconds: 5), (Timer t) => _getAlarms()); //debug output
    //_timeString = _formatDateTime(DateTime.now());
    //Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    //Timer.periodic(const Duration(seconds: 10), (Timer t) => _getAlarms());
    super.initState();
  }

  Future<bool> _getSharedPreference() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guest')!;
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  void _getAlarms() {
    if (cons.alarms.isEmpty) {
      setState(() {
        _isDeployment = false;
      });
    } else {
      setState(() {
        _alarmId = cons.alarms.elementAt(cons.showingAlarmId).Id.toString();
        _alarmSubtype = cons.alarms.elementAt(cons.showingAlarmId).Subtype.toString();
        _alarmAdress = cons.alarms.elementAt(cons.showingAlarmId).Address.toString();
        _alarmTime = cons.alarms.elementAt(cons.showingAlarmId).Time.toString();
        _alarmLat =
            cons.alarms.elementAt(cons.showingAlarmId).Lat.toString() + " " + cons.alarms.elementAt(cons.showingAlarmId).Lng.toString();
        _alarmFireDepts = cons.alarms.elementAt(cons.showingAlarmId).FireDeps
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll(', ', '');
        _isDeployment = true;
      });
      if(cons.protocols.isEmpty)
      {
        for(var i = 0; i < cons.alarms.length; i++){
          cons.protocols.add(Protocol(cons.alarms.elementAt(i).Id, cons.alarms.elementAt(i).Type, cons.alarms.elementAt(i).Address, "${cons.alarms.elementAt(i).Lat} + ${cons.alarms.elementAt(i).Lng}", cons.alarms.elementAt(i).AlarmType, DateTime.now()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //var response = getCurrentPosition().then((value) =>  getHydrants(value.longitude, value.latitude)).then((value) => convertHydrantResponse(value.body));
    final size = MediaQuery.of(context).size;
    final menuWidth = size.width;
    return Scaffold(
      backgroundColor: _backgroundColor,
      //floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: SpeedDial(
        /*shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),*/
        marginBottom: 10, //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: _openNavbarColor, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor: Colors.grey, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        buttonSize: 60, //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'), // action when menu opens
        onClose: () => print('DIAL CLOSED'), //action when menu closes
        elevation: 8.0, //shadow elevation of button
        orientation: SpeedDialOrientation.Up,
        children: [
          SpeedDialChild( //speed dial child
            child: const Icon(Icons.info_outline),
            backgroundColor: _openNavbarColor,
            foregroundColor: Colors.white,
            label: 'Info',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Navigation'),
          ),
          SpeedDialChild( //speed dial child
            child: const Icon(Icons.navigation_outlined),
            backgroundColor: _openNavbarColor,
            foregroundColor: Colors.white,
            label: 'Navigation',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                MapUtils.openMap(cons.alarms.first.Lat, cons.alarms.first.Lng);
              });
            },
            onLongPress: () => print('Navigation'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.article_outlined),
            backgroundColor: _openNavbarColor,
            foregroundColor: Colors.white,
            label: 'Protokoll',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Protokoll'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.masks_outlined),
            foregroundColor: Colors.white,
            backgroundColor: _openNavbarColor,
            label: 'Atemschutz',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Atemschutz'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.map_outlined),
            foregroundColor: Colors.white,
            backgroundColor: _openNavbarColor,
            label: 'Wasserkarte',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Wasserkarte'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.stacked_line_chart),
            foregroundColor: Colors.white,
            backgroundColor: _openNavbarColor,
            label: 'Statistik',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(4, duration: const Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Statistik'),
          ),

          //add more menu item children here
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: [
          Info(),
          const ProtocolPage(),
          OxygenPage(),
          HydrantMap(),
          LineChart()
        ],
      ),
    );
  }
}

class Info extends StatefulWidget {
  @override
  InfoPage createState() => InfoPage();
}

class InfoPage extends State<Info> with SingleTickerProviderStateMixin {
  bool _expanded = false, _isKommando = false;
  double _currentHeight = _minHeight;

  changeAlarm2 (int newAlarmId){
    setState(() {
      cons.showingAlarmId = newAlarmId;
    });
  }

  Future<bool> isKommando() async{
    var prefs = await SharedPreferences.getInstance();
    if(prefs.getString('role') == "kommando"){
      return true;
    }
    return false;
  }


  @override
  void initState() {
    setState(() {
      isKommando().then((value) => _isKommando=value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuWidth = size.width;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: _isDeployment ? _receiveDeployment() : _noDeployment(),
        ),
        /*child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Einsatzinformationen'),
                        ),
                        body: OperationInfo(),
                      );
                    });
              },
              child: Container(
                child: _isDeployment ? _receiveDeployment2() : _noDeployment(),
              ),
            ),
          ],
        ),*/
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        key: globalKey,
        onPressed: _showOverLay,
        child: const Icon(Icons.add),
      ),*/
    );
  }

  Widget _noDeployment() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Color(0xffe3e1e1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              boxShadow: [BoxShadow(
                  color: Color(0xffbfbdbd),
                  blurRadius: 6,
                  spreadRadius: 8
              )]
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                children: const <Widget>[
                  SizedBox(height: 20),
                  Text(
                    'Kein laufender Einsatz',
                    style: TextStyle(
                      color: _openNavbarColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 600,
          child: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  crossAxisCount: 2,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.masks_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Atemschutz"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffbfbdbd),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.map_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Wasserkarte"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffbfbdbd),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(4, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.stacked_line_chart,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Statistik"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffbfbdbd),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _noDeploymen2() {
    return _isGuest
        ? Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(5.w, 45.h, 5.w, 0),
      child: const Center(
        child: Text(
          "Zur Zeit liegt kein Alarm vor",
          style: TextStyle(color: Colors.black87, fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
    )
        : Column(
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xff4D4F4E),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(0, 10), // changes position of shadow
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Kein laufender Einsatz',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
            const Text(
              'Statistik',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          child: Image.asset('assets/heatmap.jpg'),
        ),
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xffB2B1B1),
            boxShadow: [
              BoxShadow(
                color: Color(0xff959090),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Mehr',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
            const Text(
              'Einsätze',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 65,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xff4D4F4E),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Vergangener Einsatz 001',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 65,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xff4D4F4E),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Vergangener Einsatz 002',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
  /// Deployment received
  Widget _receiveDeployment() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            int newAlarm = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AlarmOverview()));

            changeAlarm2(newAlarm);
            /*showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: _openNavbarColor,
                      title: const Text('Einsatzinformationen'),
                    ),
                    body: AlarmOverview(),
                  );
                });*/
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 2.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow: [BoxShadow(
                    color: _openNavbarColor,
                    blurRadius: _animation.value,
                    spreadRadius: _animation.value
                )]
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //#region Text
                    const SizedBox(height: 10),
                    const Text(
                      'Subtype',
                      style: TextStyle(
                        color: _openNavbarColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _alarmSubtype,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Adresse',
                      style: TextStyle(
                        color: _openNavbarColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _alarmAdress,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    Text(
                      _alarmLat,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Zeit',
                      style: TextStyle(
                        color: _openNavbarColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      getTime(_alarmTime),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Feuerwehren',
                      style: TextStyle(
                        color: _openNavbarColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _alarmFireDepts,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            "ID: " + _alarmId,
                            style: const TextStyle(
                              color: _openNavbarColor,
                              fontSize: 12,
                            ),
                          ),
                        ]
                    ), //#endregion
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 600,
          child: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  crossAxisCount: 2,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        MapUtils.openMap(cons.alarms.first.Lat, cons.alarms.first.Lng);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.navigation_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Maps"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isKommando,
                      child: GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.article_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Protokoll"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.masks_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Atemschutz"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.map_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Wasserkarte"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(4, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.stacked_line_chart,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Statistik"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  getTime(time){
    final splitted = time.split(' ');
    return splitted[4].split(':')[0] + ':' + splitted[4].split(':')[1];
  }
}

class OperationInfo extends StatelessWidget {
  OperationInfo({Key? key}) : super(key: key);

  final List<String> titles = [
    for ( var alarm in cons.alarms ) " ",
  ];

  @override
  Widget build(BuildContext context) {

    final List<Widget> images = [
      for ( var alarm in cons.alarms ) SingleChildScrollView (
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            //borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "ID",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                alarm.Id ?? ' ',
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
              const SizedBox(height: 50),
              const Text(
                "Subtype",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              Text(
                alarm.Subtype ?? ' ',
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
              const SizedBox(height: 50),
              const Text(
                "Addrese",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              Text(
                alarm.Address ?? ' ',
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Container(
            child: VerticalCardPager(
              textStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              titles: titles,
              images: images,
              onPageChanged: (page) {},
              align: ALIGN.CENTER,
              onSelectedItem: (index) {
                changeAlarm(index);
                Navigator.pushNamed(context, '/info');
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AlarmOverview extends StatelessWidget {
  const AlarmOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _openNavbarColor,
        title: const Text('Alarmübersicht'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              //changeAlarm(index);
              Navigator.pop(context, index);
            },
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: _openNavbarColor,
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    "Subtype",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    cons.alarms[index].Subtype ?? ' ',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Addrese",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    cons.alarms[index].Address ?? ' ',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  const SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          cons.alarms[index].Id ?? ' ',
                          style: const TextStyle(
                            color: _openNavbarColor,
                            fontSize: 12,
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: cons.alarms.length,
      ),
    );
  }
}

/*class OperationInfoAlt extends StatelessWidget {
  const OperationInfoAlt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(2.0),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Einsatz Protocol'),
                        ),
                        body: ProtocolPage(),
                      );
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height: 60.0,
                //MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width * .9,
                //MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA81A0D),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: const Icon(
                          Icons.wysiwyg_sharp,
                          color: Colors.white,
                        ),
                      );
                    }),
                    const Expanded(
                      child: Text(
                        'Einsatzprotokoll',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(2.0),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: cons.mainColor,
                          title: const Text('Alle Einsätze'),
                        ),
                        body: const ListViewBuilder(),
                      );
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height: 60.0,
                //MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width * .9,
                //MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA81A0D),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: const Icon(
                          Icons.wysiwyg_sharp,
                          color: Colors.white,
                        ),
                      );
                    }),
                    const Expanded(
                      child: Text(
                        'Alle Einsätze',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
