import 'package:flutter/material.dart';
import 'package:saferfire/temp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'Entities/alarm.dart';
import 'globals.dart' as globals;
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MaterialApp(
    home: tempState(),
  ));
}

class CurrentAlarms extends StatefulWidget {
  @override
  _CurrentAlarmsState createState() => _CurrentAlarmsState();
}

class _CurrentAlarmsState extends State<CurrentAlarms> {
  final List<String> list = [];
  late IO.Socket socket;

  @override
  void initState() {
    socket = IO.io('http://86.56.241.47:3030/alarms');
    socket.connect();
    socket.onConnect((_) {
      print('Connected');
    });
    socket.on('alarmsRes', (data) => print(data));
    super.initState();
  }



  void connectToSocket() {
    socket.emit("alarmsReq",
      {
        "username": 'AppTestUser',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search for Alarms'),
          backgroundColor: Colors.red,
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              Column(
                children: list.map((e) => Text(e)).toList(),
              )
            ])),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(Icons.search),
            onPressed: connectToSocket),
      ),
    );
  }
}
