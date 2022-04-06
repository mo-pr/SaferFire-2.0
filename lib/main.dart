import 'package:flutter/material.dart';
import 'package:saferfire/loginPage.dart';
<<<<<<< HEAD
import 'package:saferfire/navigation.dart';
import "package:saferfire/authentication.dart";
import 'package:saferfire/toolProtocol.dart';
=======
import "package:sizer/sizer.dart";
>>>>>>> origin/dev-preining

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Protocol(),
=======
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Login(),
        );
      },
>>>>>>> origin/dev-preining
    );
  }
}
