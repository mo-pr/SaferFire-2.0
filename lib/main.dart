import 'package:flutter/material.dart';
import 'package:saferfire/infoPage.dart';
import 'package:saferfire/loginPage.dart';
import 'package:saferfire/pages/oxygentool_page.dart';
import 'package:saferfire/toolProtocol.dart';
import 'package:saferfire/views/brand_view.dart';
import 'package:saferfire/views/grundinformationen_view.dart';
import "package:sizer/sizer.dart";
import 'package:saferfire/models/Protocol.dart';


const _cardBackgroundColor = Color(0xFFbb1e10);

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.ß
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Safer - Fire',
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) =>  Login(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/info': (context) => Info(),
            '/protocol': (context) => ProtocolPage(),
            '/einsatzuebersicht': (context) => const OperationInfo(),
          },
          theme: ThemeData(
            primaryColor: Color(0xFFbb1e10),
            buttonColor: Color(0xFFbb1e10),
          ),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  PageController _pageController = new PageController();
  List<Widget> _screens = [

  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}


