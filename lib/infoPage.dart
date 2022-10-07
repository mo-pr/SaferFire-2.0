import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:saferfire/notificationservice.dart';
import 'package:saferfire/pages/oxygentool_page.dart';
import 'package:saferfire/toolProtocol.dart';
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

//String _timeString = "";

class Info extends StatefulWidget {
  @override
  InfoPage createState() => InfoPage();
}

class InfoPage extends State<Info> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  List<Widget> _screens = <Widget>[
    OverviewPage(),
    ProtocolPage(),
    OxygenPage()
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late Socket socket;
  late AnimationController _controller;
  bool _expanded = false;
  double _currentHeight = _minHeight;

  Future<void> _websocketReq() async {
    var prefs = await SharedPreferences.getInstance();
    if (isTest) {
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  Future<bool> _getSharedPreference() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guest')!;
  }

  @override
  void dispose() {
    socket.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuWidth = size.width;
    return Scaffold(
        backgroundColor: _backgroundColor,
        body: SingleChildScrollView(
          child: Column(
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
                  child: _isDeployment ? _receiveDeployment() : _noDeployment(),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "_timeString",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: GestureDetector(
            //#region Drag
            onVerticalDragUpdate: _expanded
                ? (details) {
                    setState(() {
                      final newHeight = _currentHeight - details.delta.dy;
                      _controller.value = _currentHeight / _maxHeight;
                      _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
                    });
                  }
                : null,
            onVerticalDragEnd: _expanded
                ? (details) {
                    if (_currentHeight < _maxHeight / 1.5) {
                      _controller.reverse();
                      _expanded = false;
                      _cardColor = Colors.white;
                    } else {
                      _expanded = true;
                      _controller.forward(from: _currentHeight / _maxHeight);
                      _currentHeight = _maxHeight;
                      _cardColor = const Color(0xFFbb1e10);
                    }
                  }
                : null,
            //#endregion
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) {
                //final value = _controller.value;
                final value =
                    const ElasticInOutCurve(0.9).transform(_controller.value);
                return Stack(
                  children: [
                    Positioned(
                      height: lerpDouble(_minHeight, _currentHeight, value),
                      left:
                          lerpDouble(size.width / 2 - menuWidth / 2, 0, value),
                      width: lerpDouble(menuWidth, size.width, value),
                      bottom: lerpDouble(0.0, 0.0, value),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                        ),
                        child: _expanded
                            ? _buildExpandedContent()
                            : _buildMenuContent(),
                      ),
                    ),
                  ],
                );
              },
            )));
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
                  const Text(
                    'Einsatzdaten',
                    style: TextStyle(
                        color: _openNavbarColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ID: " + _alarmId,
                    style: const TextStyle(
                      color: _openNavbarColor,
                      fontSize: 25,
                    ),
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

  /// Content for the extended bottomNavigationBar
  Widget _buildExpandedContent() {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    height: 80,
                    width: 310,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        minimumSize: Size(80, 80),
                      ),
                      onPressed: () {
                        _onItemTapped(2);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => ProtocolPage(alarm: alarms.first))
                        // );
                      },
                      child: const Text('Info'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 80,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: Size(80, 80), //////// HERE
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OxygenPage()),
                        );
                      },
                      child: const Text('Oxygen'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 80,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: Size(80, 80), //////// HERE
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OxygenPage()),
                        );
                      },
                      child: const Text('Foto'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    color: Colors.black,
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    color: Colors.black,
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    color: Colors.black,
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  // Widget _showProtocolPage(){
  //
  // }

  /// Content for the smaller bottomNavigationBar
  Widget _buildMenuContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {},
          child: const Icon(Icons.masks, size: 30.0),
        ),
        MaterialButton(
          onPressed: () {
            setState(() {
              _expanded = true;
              _currentHeight = _maxHeight;
              _controller.forward(from: 0.0);
              _cardColor = const Color(0xFFbb1e10);
            });
          },
          color: const Color(0xFFA81A0D),
          child: const Icon(Icons.add, size: 60.0),
          padding: const EdgeInsets.all(5),
        ),
        /*GestureDetector(
          onTap: (){
            setState(() {
              _expanded = true;
              _currentHeight = _maxHeight;
              _controller.forward(from: 0.0);
            });
          },
          child: Icon(Icons.add, size: 80.0),
        ),*/
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OxygenPage()),
            );
          },
          child: const Icon(Icons.timer, size: 30.0),
        ),
      ],
    );
  }

  /// returns the current time for the clock
  // void _getTime() {
  //   final DateTime now = DateTime.now();
  //   final String formattedDateTime = _formatDateTime(now);
  //   setState(() {
  //     _timeString = formattedDateTime;
  //   });
  // }

  void _getAlarms() {
    if (alarms.isEmpty) {
      setState(() {
        _isDeployment = false;
      });
    } else {
      setState(() {
        _alarmId = alarms.first.Id.toString();
        _alarmSubtype = alarms.first.Subtype.toString();
        _alarmAdress = alarms.first.Address.toString();
        _alarmLat =
            alarms.first.Lat.toString() + " " + alarms.first.Lng.toString();
        _alarmFireDepts = alarms.first.FireDeps
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll(', ', '');
        _isDeployment = true;
      });
    }
  }

  /// converts the DateTime in a string (uses intl 0.17.0)
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy hh:mm:ss').format(dateTime);
  }
}

class OverviewPage extends StatefulWidget {
  @override
  _OverViewPageState createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Column(
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
                child: _isDeployment ? _receiveDeployment() : _noDeployment(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "_timeString",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
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
                  const Text(
                    'Einsatzdaten',
                    style: TextStyle(
                        color: _openNavbarColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ID: " + _alarmId,
                    style: const TextStyle(
                      color: _openNavbarColor,
                      fontSize: 25,
                    ),
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy hh:mm:ss').format(dateTime);
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
