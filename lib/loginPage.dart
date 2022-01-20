import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saferfire/infoPage.dart';

const _backgroundColor = Color(0xFFE5E5E5);
const _cardBackgroundColor = Color(0xFFbb1e10);

class Login extends StatefulWidget {
  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  bool isLoginScreen = true;

  ChangeTo() {
    setState(() {
      isLoginScreen = !isLoginScreen;
    });
  }

  ///Gets called when the "Sign In" Button is Pressed
  Login() {}

  ///Gets called when the "Sign Up" Button is Pressed
  Register() {}

  String _timeString = "";

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuWidh = size.width;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: _backgroundColor,
          ),
          new Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: _cardBackgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 90.0),
            alignment: Alignment.topCenter,
            child: Text(
              'SaferFire',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          new Align(
            alignment: Alignment.center,
            child: isLoginScreen ? _login() : _register(),
          ),
        ],
      ),
      extendBody: true,
    );
  }

  /// returns the Container for the login
  Widget _login() {
    return Container(
        height: 400,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
          child: Column(
            children: [
              Text(
                'Willkommen zu SaferFire',
                style: TextStyle(
                    color: Colors.red[500],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 45),

              ///Button for Sign In
              new MaterialButton(
                onPressed: () => Login(),
                minWidth: MediaQuery.of(context).size.width,
                color: _cardBackgroundColor,
                textColor: Colors.black,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //side: BorderSide(color: Colors.red)
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'or',
                style: TextStyle(
                    color: _cardBackgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              ///Button for Sign UP
              new MaterialButton(
                onPressed: () => ChangeTo(),
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.white,
                textColor: Colors.black,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: _cardBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: _cardBackgroundColor)),
              ),
            ],
          ),
        ));
  }

  /// returns the Container for the register
  Widget _register() {
    return Container(
        height: 500,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
          child: Column(
            children: [
              Text(
                'Willkommen zu SaferFire',
                style: TextStyle(
                    color: Colors.red[500],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Feuerwehr',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 40),

              ///Button for Sign UP
              new MaterialButton(
                onPressed: () => Register(),
                minWidth: MediaQuery.of(context).size.width,
                color: _cardBackgroundColor,
                textColor: Colors.black,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //side: BorderSide(color: Colors.red)
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'or',
                style: TextStyle(
                    color: _cardBackgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              ///Button for Sign In
              new MaterialButton(
                onPressed: () => ChangeTo(),
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.white,
                textColor: Colors.black,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: _cardBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: _cardBackgroundColor)),
              ),
            ],
          ),
        ));
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
