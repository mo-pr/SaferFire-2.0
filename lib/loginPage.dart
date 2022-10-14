import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saferfire/authentication.dart';
import 'package:saferfire/infoPage.dart';
import 'package:saferfire/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:timezone/data/latest.dart' as tz;


const _backgroundColor = Color(0xFFE5E5E5);
const _cardBackgroundColor = Color(0xFFbb1e10);

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  final _keyL = GlobalKey<FormState>(),
      _keyR = GlobalKey<FormState>(),
      _keyG = GlobalKey<FormState>();
  bool isLoginScreen = true, isGuestScreen = false;
  String email = "", password = "", firedep = "";

  ///Gets called when the "Sign In" Button is Pressed
  login() async {
    final form = _keyL.currentState;
    if (form!.validate()) {
      form.save();
      baseLogin(email, password);
    }
  }
  baseLogin(String email, String password) async{
    var res = await UserAuthentication.login(email, password);
    if (res.statusCode == 200) {
      Map<String, dynamic> claims = JwtDecoder.decode(res.body);
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('token', res.body);
      prefs.setString('firestation', claims["firestation"].toString());
      prefs.setBool('guest', false);
      password = email = "";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Start()),
      );
    }
  }
  ///Gets called when the "Sign Up" Button is Pressed
  register() async {
    final form = _keyR.currentState;
    if (form!.validate()) {
      form.save();
      var res = await UserAuthentication.register(email, password, firedep);
      if (res.statusCode == 201) {
        await baseLogin(email, password);
      }
    }
  }

  registerGuestUser() async {
    final form = _keyG.currentState;
    if (form!.validate()) {
      form.save();
      var res = await UserAuthentication.createGuest(firedep);
      if (res.statusCode == 200) {
        Map<String, dynamic> claims = JwtDecoder.decode(res.body);
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res.body);
        prefs.setString('firestation', claims["firestation"].toString());
        prefs.setBool('guest', true);
        firedep = "";
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Start()),
        );
      }
    }
  }

  Widget getScreen() {
    if (isLoginScreen) {
      return _login();
    } else {
      if (!isGuestScreen) {
        return _register();
      } else {
        return _registerGuest();
      }
    }
  }

  String _timeString = "";

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();

    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: _backgroundColor,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: _cardBackgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 90.0),
            alignment: Alignment.topCenter,
            child: const Text(
              'SaferFire',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: getScreen(),
          ),
        ],
      ),
      extendBody: true,
    );
  }

  /// returns the Container for the login
  Widget _login() {
    return Container(
        height: 450,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
          child: Form(
            key: _keyL,
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
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "E-Mail darf nicht leer sein!";
                    }
                    if (Validator.validateEmail(e) == false) {
                      return "Ungültige E-Mail!";
                    }
                    return null;
                  },
                  onSaved: (e) => email = e!,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Passwort darf nicht leer sein!";
                    }
                    if (Validator.validatePassword(e) == false) {
                      return "Ungültiges Passwort!";
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (e) => password = e!,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 45),

                ///Button for Sign In
                MaterialButton(
                  onPressed: () => login(),
                  minWidth: MediaQuery.of(context).size.width,
                  color: _cardBackgroundColor,
                  textColor: Colors.black,
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    //side: BorderSide(color: Colors.red)
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'or',
                  style: TextStyle(
                      color: _cardBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                ///Button for Sign UP
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      isLoginScreen = false;
                      isGuestScreen = false;
                    });
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  textColor: Colors.black,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: _cardBackgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: _cardBackgroundColor)),
                ),
              ],
            ),
          ),
        ));
  }

  /// returns the Container for the register
  Widget _register() {
    return Container(
        height: 600,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
          child: Form(
            key: _keyR,
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
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "E-Mail darf nicht leer sein!";
                    }
                    if (Validator.validateEmail(e) == false) {
                      return "Ungültige E-Mail!";
                    }
                    return null;
                  },
                  onSaved: (e) => email = e!,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Feuerwehr darf nicht leer sein!";
                    }
                    if (Validator.validateFirestation(e) == false) {
                      return "Ungültige Feuerwehr!";
                    }
                    return null;
                  },
                  onSaved: (e) => firedep = e!,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Feuerwehr',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Passwort darf nicht leer sein!";
                    }
                    if (Validator.validatePassword(e) == false) {
                      return "Ungültiges Passwort!";
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (e) => password = e!,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 40),

                ///Button for Sign UP
                MaterialButton(
                  onPressed: () => register(),
                  minWidth: MediaQuery.of(context).size.width,
                  color: _cardBackgroundColor,
                  textColor: Colors.black,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    //side: BorderSide(color: Colors.red)
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'or',
                  style: TextStyle(
                      color: _cardBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                ///Button for Sign In
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      isLoginScreen = true;
                      isGuestScreen = false;
                    });
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  textColor: Colors.black,
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                        color: _cardBackgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: _cardBackgroundColor)),
                ),
                const SizedBox(height: 5),
                const Text(
                  'or',
                  style: TextStyle(
                      color: _cardBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                ///Button for Sign In
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      isLoginScreen = false;
                      isGuestScreen = true;
                    });
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  textColor: Colors.black,
                  child: const Text(
                    "Create Guest User",
                    style: TextStyle(
                        color: _cardBackgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: _cardBackgroundColor)),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _registerGuest() {
    return Container(
        height: 350,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
          child: Form(
            key: _keyG,
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
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Feuerwehr darf nicht leer sein!";
                    }
                    if (Validator.validateFirestation(e) == false) {
                      return "Ungültige Feuerwehr!";
                    }
                    return null;
                  },
                  onSaved: (e) => firedep = e!,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Feuerwehr',
                  ),
                ),
                const SizedBox(height: 45),

                MaterialButton(
                  onPressed: () => registerGuestUser(),
                  minWidth: MediaQuery.of(context).size.width,
                  color: _cardBackgroundColor,
                  textColor: Colors.black,
                  child: const Text(
                    "Create Guest User",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    //side: BorderSide(color: Colors.red)
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'or',
                  style: TextStyle(
                      color: _cardBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                ///Button for Sign UP
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      isLoginScreen = false;
                      isGuestScreen = false;
                    });
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  textColor: Colors.black,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: _cardBackgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: _cardBackgroundColor)),
                ),
              ],
            ),
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
