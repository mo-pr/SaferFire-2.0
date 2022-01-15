import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage()
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alarms"),
          backgroundColor: Colors.cyan,
        ),
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Alarms()))
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        )
    );
  }
}

class Alarms extends StatefulWidget {
  @override
  State<Alarms> createState() => AlarmState();
}

class AlarmState extends State<Alarms> {
  late Socket socket;

  @override
  void initState(){
    socket = io('http://86.56.241.47:3030/alarms', <String, dynamic>{'transports': ['websocket'], 'forceNew': true});
    socket.connect();
    socket.on('alarmsRes', (data) => print(data));
    socket.on('connect_error', (data) => print("ConnErr: "+data)); //debug output
    socket.on('connect_timeout', (data) => print("ConnTo: "+data)); //debug output
    socket.on('connect', (data)=>print("Conn: "+data)); //debug output
    socket.on('disconnect', (data) => print("DConn: "+data)); //debug output
    socket.on('error', (data) => print("Err: "+data)); //debug output
    super.initState();
  }
  
  void sendRequest(){
    socket.emit('alarmsReq',json.encode({'username':'Test'}));
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alarms-Client"),
          backgroundColor: Colors.red,
        ),
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
              print("Pressed...");
              sendRequest();
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
