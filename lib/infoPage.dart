import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:saferfire/notificationservice.dart';
import 'package:saferfire/pages/oxygentool_page.dart';
import 'package:saferfire/pages/toolProtocol.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saferfire/alarm.dart';
import 'package:saferfire/constants.dart';
import 'package:saferfire/loginPage.dart';
import 'package:saferfire/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
late Socket socket;

//String _timeString = "";
PageController _pageController = PageController(initialPage: 0);

class Start extends StatefulWidget {
  @override
  StartPage createState() => StartPage();
}

class StartPage extends State<Start> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  Future<void> _websocketReq() async {
    var prefs = await SharedPreferences.getInstance();
    if  (isTest)  {
      socket.emit('alarmsReq',
          json.encode({'token': prefs.getString('token'), "count": 4}));
    }
    if (!isTest) {
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

  @override
  void initState() {
    setState(() {
      _getSharedPreference().then((value) => _isGuest = value);
    });
    if (isTest) {
      socket = io('http://$ipAddress/testalarms', <String, dynamic>{
        'transports': ['websocket'],
        'forceNew': true
      });
    }
    if (!isTest) {
      socket = io('http://$ipAddress/alarms', <String, dynamic>{
        'transports': ['websocket'],
        'forceNew': true
      });
    }
    socket.connect();
    _websocketReq();
    socket.on('alarmsRes', (data) async {
      print(data);
      Alarm alarm = new Alarm(data);
      for (int i = 0; i < alarms.length; i++) {
        if (alarms[i].Id == alarm.Id) {
          return alarms;
        }
      }
      alarms.add(alarm);

      //If you get alarm for your firestation, get push notification
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var firestation = prefs.getString('firestation');
      if (alarm.FireDeps.toString()
          .contains(firestation!)) //if alarm is for your firestation
      {
        NotificationService().showNotification(
            0,
            "A new alarm has appeared",
            "Alarm type: ${alarm.AlarmType}   Address: ${alarm.Address}",
            2); //you get a push notification
      }

      return alarms;
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
    if (alarms.isEmpty) {
      setState(() {
        _isDeployment = false;
      });
    } else {
      setState(() {
        _alarmId = alarms.elementAt(0).Id.toString();
        _alarmSubtype = alarms.elementAt(0).Subtype.toString();
        _alarmAdress = alarms.elementAt(0).Address.toString();
        _alarmLat =
            alarms.elementAt(0).Lat.toString() + " " + alarms.elementAt(0).Lng.toString();
        _alarmFireDepts = alarms.elementAt(0).FireDeps
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll(', ', '');
        _isDeployment = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Icon(Icons.info_outline),
            backgroundColor: _openNavbarColor,
            foregroundColor: Colors.white,
            label: 'Info',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Navigation'),
          ),
          SpeedDialChild( //speed dial child
            child: Icon(Icons.navigation_outlined),
            backgroundColor: _openNavbarColor,
            foregroundColor: Colors.white,
            label: 'Navigation',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                MapUtils.openMap(alarms.first.Lat, alarms.first.Lng);
              });
            },
            onLongPress: () => print('Navigation'),
          ),
          SpeedDialChild(
            child: Icon(Icons.article_outlined),
            backgroundColor: _openNavbarColor,
            foregroundColor: Colors.white,
            label: 'Protokoll',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Protokoll'),
          ),
          SpeedDialChild(
            child: Icon(Icons.masks_outlined),
            foregroundColor: Colors.white,
            backgroundColor: _openNavbarColor,
            label: 'Atemschutz',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onLongPress: () => print('Atemschutz'),
          ),

          //add more menu item children here
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: [
          Info(),
          ProtocolPage(),
          OxygenPage(),
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
  bool _expanded = false;
  double _currentHeight = _minHeight;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuWidth = size.width;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: _isDeployment ? _receiveDeployment2() : _noDeployment(),
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
        Container(
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xff4D4F4E),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(0, 10), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //#region Text
                  const SizedBox(height: 30),
                  Text(
                    "ID: " + _alarmId,
                    style: const TextStyle(
                      color: _openNavbarColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Einsatzdaten',
                    style: TextStyle(
                        color: _openNavbarColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Subtype',
                    style: TextStyle(
                      color: _openNavbarColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _alarmSubtype,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Adresse',
                    style: TextStyle(
                      color: _openNavbarColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _alarmAdress,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    _alarmLat,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Feuerwehren',
                    style: TextStyle(
                      color: _openNavbarColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _alarmFireDepts,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  //#endregion
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
        Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(2.0),
          child: InkWell(
            onTap: () {
              MapUtils.openMap(alarms.first.Lat, alarms.first.Lng);
            },
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 60.0,
              //MediaQuery.of(context).size.width * .08,
              width: 220.0,
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
                        color: _openNavbarColor,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: const Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    );
                  }),
                  const Expanded(
                    child: Text(
                      'Open Maps',
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
        const SizedBox(height: 90),
        /*new Container(
          height: 65,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xff4D4F4E),
            boxShadow: [
              BoxShadow(
                color: Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Vergangene Einsätze',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),*/
      ],
    );
  }

  /// Deployment received
  Widget _receiveDeployment2() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: _openNavbarColor,
                      title: const Text('Einsatzinformationen'),
                    ),
                    body: OperationInfo(),
                  );
                });
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 2.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: _openNavbarColor,
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //#region Text
                    const SizedBox(height: 30),
                    Text(
                      "ID: " + _alarmId,
                      style: const TextStyle(
                        color: _openNavbarColor,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      'Einsatzdaten',
                      style: TextStyle(
                          color: _openNavbarColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
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
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    Text(
                      _alarmLat,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(height: 15),
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
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    //#endregion
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
                        MapUtils.openMap(alarms.first.Lat, alarms.first.Lng);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.navigation_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Maps"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.article_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Protokoll"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.masks_outlined,
                              size: 100.0,
                              color: _openNavbarColor,
                            ), // <-- Icon
                            Text("Atemschutz"), // <-- Text
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: _openNavbarColor,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: _openNavbarColor,
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: _openNavbarColor,
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: _openNavbarColor,
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
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
}

class OperationInfo extends StatelessWidget {
  const OperationInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
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
                          color: Color(0xFFA81A0D),
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
          SizedBox(height: 15),
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
                          backgroundColor: mainColor,
                          title: const Text('Alle Einsätze'),
                        ),
                        body: ListViewBuilder(),
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
                          color: Color(0xFFA81A0D),
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
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE5E5E5),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                const Text(
                  "ID",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  alarms[index].Id ?? ' ',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Subtype",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  alarms[index].Subtype ?? ' ',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Addrese",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  alarms[index].Address ?? ' ',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
      itemCount: alarms.length,
    );
  }
}
