import 'package:flutter/material.dart';
import 'package:saferfire/infoPage.dart';
import 'package:saferfire/navigation.dart';
import "package:saferfire/authentication.dart";
import 'package:http/http.dart' as http;

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Info(),
    );
  }
}

