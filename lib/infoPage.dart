import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saferfire/alarm.dart';
import 'package:saferfire/helper.dart';
import 'package:saferfire/navigation.dart';
import 'package:saferfire/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

var _cardColor = Color(0xFFbb1e10);
const _openNavbarColor = Color(0xFFbb1e10);
const _backgroundColor = Colors.white;
const _maxHeight = 350.0;
const _minHeight = 70.0;
List _allDeployments = [];
List<Alarm> alarms = List.empty();

class DeploymentInfo {
  late int id;
  late String missionNumber;
  late String location;
  late DateTime timestamp;
  late int alertLevel;
  late String typeOfOperation;
  late String fireStation;

  String _place = "";
  String _kind = "";
  String _fireDepartments = "";

  DeploymentInfo(String place, String kind, String fireDepartments) {
    _place = place;
    _kind = kind;
    _fireDepartments = fireDepartments;
  }

  String GetPlace() {
    return _place;
  }

  String GetKind() {
    return _kind;
  }

  String GetFireDepartments() {
    return _fireDepartments;
  }
}

class Info extends StatefulWidget {
  @override
  InfoPage createState() => InfoPage();
}

class InfoPage extends State<Info> with SingleTickerProviderStateMixin {
  late Socket socket;
  late AnimationController _controller;
  bool _expanded = false;
  bool _isDeployment = false;
  double _currentHeight = _minHeight;
  String _timeString = "";

  String _alarmId = " ";
  String _alarmSubtype = " ";
  String _alarmAdress = " ";
  String _alarmLat = " ";
  String _alarmFireDepts = " ";
  Helper h = new Helper();

  Future<void> _websocketReq()async{
    var prefs = await SharedPreferences.getInstance();
    socket.emit('alarmsReq', json.encode({'token': prefs.getString('token')}));
  }

  void logout() async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  void initState() {
    socket = io('http://86.56.241.47:3030/alarms', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true
    });
    socket.connect();
    _websocketReq();
    socket.on('alarmsRes', (data) {
      print(data);
      alarms = h.GetAlarmsFromString(data);
    });
    socket.on(
        'connect_error', (data) => print("ConnErr: " + data)); //debug output
    socket.on('error', (data) => print("Err: " + data));
    Timer.periodic(Duration(seconds: 5), (Timer t) => _getAlarms());//debug output
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
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
    final menuWidh = size.width;
    return Scaffold(
        backgroundColor: _backgroundColor,
        body: SingleChildScrollView(
          child: new Column(
            children: [
              new GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text('Second Route'),
                          ),
                          body: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: ListViewBuilder(),
                            ),
                          ),
                        );
                      });
                  print("Container clicked");
                },
                child: new Container(
                  child: _isDeployment ? _receiveDeployment() : _noDeployment(),
                ),
              ),
              const SizedBox(height: 10),
              new Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    _timeString,
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                      _cardColor = Color(0xFFbb1e10);
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
                      left: lerpDouble(size.width / 2 - menuWidh / 2, 0, value),
                      width: lerpDouble(menuWidh, size.width, value),
                      bottom: lerpDouble(0.0, 0.0, value),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.vertical(
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

  /// there is no deployment right now
  Widget _noDeployment() {
    return Column(
      children: [
        new Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xff4D4F4E),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 10), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
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
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
            new Text(
              'Statistik',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            new Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
          ],
        ),
        const SizedBox(height: 5),
        new Container(
          child: Image.asset('assets/heatmap.jpg'),
        ),
        new Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
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
          child: Center(
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
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
            Text(
              'Einsätze',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            new Container(
              color: Colors.black,
              height: 4,
              width: 80,
            ),
          ],
        ),
        const SizedBox(height: 10),
        new Container(
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
        new Container(
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
        new Container(
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xff4D4F4E),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 10), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                //#region Text
                const SizedBox(height: 30),
                Text(
                  'Einsatzdaten',
                  style: TextStyle(
                      color: _openNavbarColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "ID: " + _alarmId,
                  style: TextStyle(
                    color: _openNavbarColor,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Subtype',
                  style: TextStyle(
                      color: _openNavbarColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _alarmSubtype,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 15),
                Text(
                  'Adresse',
                  style: TextStyle(
                    color: _openNavbarColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _alarmAdress,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  _alarmLat,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 15),
                Text(
                  'Feuerwehren',
                  style: TextStyle(
                    color: _openNavbarColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _alarmFireDepts,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                //#endregion
              ],
            ),
          ),
        ),
        const SizedBox(height: 50),
        new Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(2.0),
          child: InkWell(
            onTap: () {
              MapUtils.openMap(alarms.first.Lat,alarms.first.Lng);
            },
            child: Container(
              padding: EdgeInsets.all(0.0),
              height: 60.0,//MediaQuery.of(context).size.width * .08,
              width: 220.0,//MediaQuery.of(context).size.width * .3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Row(
                children: <Widget>[
                  LayoutBuilder(builder: (context, constraints) {
                    print(constraints);
                    return Container(
                      height: constraints.maxHeight,
                      width: constraints.maxHeight,
                      decoration: BoxDecoration(
                        color: _openNavbarColor,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    );
                  }),
                  Expanded(
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

  /// Content for the smaller bottomNavigationBar
  Widget _buildMenuContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {},
          child: Icon(Icons.masks, size: 30.0),
        ),
        new MaterialButton(
          onPressed: () {
            setState(() {
              _expanded = true;
              _currentHeight = _maxHeight;
              _controller.forward(from: 0.0);
              _cardColor = Color(0xFFbb1e10);
            });
          },
          color: Color(0xFFA81A0D),
          child: Icon(Icons.add, size: 60.0),
          padding: EdgeInsets.all(5),
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
          onTap: () {},
          child: Icon(Icons.timer, size: 30.0),
        ),
      ],
    );
  }

  /// returns the current time for the clock
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  void _getAlarms(){
    if (alarms.isEmpty) {
      setState(() {
        _isDeployment = false;
      });
    } else {
      setState(() {
        _alarmId = alarms.first.Id.toString();
        _alarmSubtype = alarms.first.Subtype.toString();
        _alarmAdress = alarms.first.Address.toString();
        _alarmLat = alarms.first.Lat.toString()+" "+alarms.first.Lng.toString();
        _alarmFireDepts = alarms.first.FireDeps.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(', ', '');
        _isDeployment = true;
      });
    }
  }

  /// converts the DateTime in a string (uses intl 0.17.0)
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy hh:mm:ss').format(dateTime);
  }
}

class ListViewBuilder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            color: _openNavbarColor,
            child: Column(
              children: [
                const SizedBox(height: 5),
                new Text(
                  "ID",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                new Text(
                  alarms[index].Id ?? ' ',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                new Text(
                  "Subtype",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                new Text(
                  alarms[index].Subtype ?? ' ',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
      itemCount: alarms.length,
    );
  }
}
