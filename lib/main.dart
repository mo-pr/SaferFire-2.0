import 'package:flutter/material.dart';
import 'package:saferfire/loginPage.dart';
import 'package:saferfire/navigation.dart';
import "package:saferfire/authentication.dart";
import 'package:saferfire/toolProtocol.dart';
import "package:sizer/sizer.dart";


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.ß
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: Login(),
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


