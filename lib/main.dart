import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saferfire/notificationservice.dart';
import 'package:saferfire/infoPage.dart';
import 'package:saferfire/loginPage.dart';
import 'package:saferfire/pages/protocoltool_page.dart';
import "package:sizer/sizer.dart";

<<<<<<< HEAD
import 'authentication.dart';
import 'loginPageTwo.dart';

const _cardBackgroundColor = Color(0xFFbb1e10);

=======
>>>>>>> ba03dd7d767c97e01e7b9a81d5f56806285e604d
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Safer - Fire',
          initialRoute: '/',
          routes: {
<<<<<<< HEAD
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => LoginTwo(),
            // When navigating to the "/second" route, build the SecondScreen widget.
=======
            '/': (context) => const Login(),
>>>>>>> ba03dd7d767c97e01e7b9a81d5f56806285e604d
            '/info': (context) => Start(),
            '/protocol': (context) => const ProtocolPage(),
            '/einsatzuebersicht': (context) => OperationInfo(),
          },
          theme: ThemeData(
            primaryColor: const Color(0xFFbb1e10),
          ),
        );
      },
    );
  }
}