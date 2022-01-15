import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _cardColor = Color(0xFFF7883C);
const _maxHeight = 350.0;
const _minHeight = 70.0;

class DeploymentInfo {

  String _place = "";
  String _kind = "";
  String _fireDepartments = "";

  DeploymentInfo(String place, String kind, String fireDepartments){
    _place = place;
    _kind = kind;
    _fireDepartments = fireDepartments;
  }

  String GetPlace(){
    return _place;
  }

  String GetKind(){
    return _kind;
  }

  String GetFireDepartments() {
    return _fireDepartments;
  }
}

class Info extends StatefulWidget {
  /*@override
  Widget build(BuildContext context) {
    return MaterialApp( //use MaterialApp() widget like this
        home: InfoPage() //create new widget class for this 'home' to
      // escape 'No MediaQuery widget found' error
    );
  }*/
  @override
  InfoPage createState() => InfoPage();
}

class InfoPage extends State<Info> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  bool _expanded = false;
  double _currentHeight = _minHeight;
  String _timeString = "";

  DeploymentInfo _deploymentInfo = new DeploymentInfo("Zwettl an der Rodle; 4180 / Hochgarten 12", "Hausbrand; schwer", "Feuerwehren; Zwettl / Oberneukirchen / Bad Leonfelden");

  @override
  void initState() {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuWidh = size.width;
    return Scaffold(
      backgroundColor: Color(0xffD1D1D1),
      body: SingleChildScrollView(
        child: new Column(
          children: [
            new Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xff4D4F4E),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff333333).withOpacity(1),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 30), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    //#region Text
                    Text(
                      'Einsatzdaten',
                      style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '001',
                      style: TextStyle(
                          color: Colors.red[500]),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _deploymentInfo.GetPlace().split(";")[0],
                      style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 25),
                    ),
                    Text(
                      _deploymentInfo.GetPlace().split(";")[1],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _deploymentInfo.GetKind().split(";")[0],
                      style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 25),
                    ),
                    Text(
                      _deploymentInfo.GetKind().split(";")[1],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _deploymentInfo.GetFireDepartments().split(";")[0],
                      style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 25),
                    ),
                    Text(
                      _deploymentInfo.GetFireDepartments().split(";")[1],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15),
                    ),
                    //#endregion
                  ],
                ),
              ),
            ),
            new MaterialButton(
              onPressed: () {},
              color: Color(0xffFF5929),
              textColor: Colors.black,
              child: Column(
                children: [
                  Icon(Icons.navigation, size: 80,),
                  Text("Route"),
                ],
              ),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            ),
            const SizedBox(height: 15),
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
                  'Vergangene Einsätze',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            new Container(
              height: 65,
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
            if(_currentHeight < _maxHeight / 1.5){
              _controller.reverse();
              _expanded = false;
            } else {
              _expanded = true;
              _controller.forward(from: _currentHeight / _maxHeight);
              _currentHeight = _maxHeight;
            }
          } : null,
          //#endregion
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, snapshot){
              //final value = _controller.value;
              final value = const ElasticInOutCurve(0.9).transform(_controller.value);
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
                      child: _expanded? _buildExpandedContent() : _buildMenuContent(),
                    ),
                  ),
                ],
              );
            },
          )
      )
    );
  }

  /// Content for the extended bottomNavigationBar
  Widget _buildExpandedContent(){
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
        )
    );
  }

  /// Content for the smaller bottomNavigationBar
  Widget _buildMenuContent(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: (){
          },
          child: Icon(Icons.masks, size: 30.0),
        ),
        new MaterialButton(
          onPressed: () {
            setState(() {
              _expanded = true;
              _currentHeight = _maxHeight;
              _controller.forward(from: 0.0);
            });
          },
          color: Color(0xFFF7883C),
          child: Icon(Icons.add, size: 60.0),
          padding: EdgeInsets.all(5),
          shape: CircleBorder(),
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
          onTap: (){
          },
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

  /// converts the DateTime in a string (uses intl 0.17.0)
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy hh:mm:ss').format(dateTime);
  }
}