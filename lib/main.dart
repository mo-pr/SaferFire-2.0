import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:saferfire/infoPage.dart';
import 'package:saferfire/loginPage.dart';
import 'package:saferfire/pages/oxygentool_page.dart';
import 'package:saferfire/toolProtocol.dart';
import 'package:saferfire/views/brand_view.dart';
import 'package:saferfire/views/grundinformationen_view.dart';
import "package:sizer/sizer.dart";
import 'package:saferfire/models/Protocol.dart';

const _cardBackgroundColor = Color(0xFFbb1e10);

//for push notification
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', //id
  'High Importance Notifications', //title
  description: 'This channel is used for important notifications.', //description
  importance: Importance.high,
  playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up: ${message.messageId}');
}

class _MainPageState extends State<MainPage>{
  PageController _pageController = new PageController();
  List<Widget> _screens = [

  ];

  void showNotification() {
    setState(() {
      //counter?
    });
    flutterLocalNotificationsPlugin.show(
      0,
      "Testing 1",
      "How are you?",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.high,
          color: Colors.blue,
          playSound: true
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              //icon: '@mipmap/ic_launcher',
            ),
          )
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('${notification.title}'), //error fixed with $'{..}'
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${notification.body}')
                  ],
                ),
              ),
            );
          });
      }
    });
  }
}
//End of Push Notification

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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



