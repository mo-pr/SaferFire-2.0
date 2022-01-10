import 'package:flutter/material.dart';
import 'Entities/alarm.dart';
import 'globals.dart' as globals;
import'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(AlarmsApp());

class AlarmsApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Alarms',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: CurrentAlarms()
    );
  }
}

class CurrentAlarms extends StatefulWidget{
  @override
  _CurrentAlarmsState createState() => _CurrentAlarmsState();
}

class _CurrentAlarmsState extends State<CurrentAlarms>{
  late WebSocketChannel channel;
  final List<String> list = [];

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect(globals.uri);
    channel.stream.listen((data) => setState(() => list.add(Alarm.fromJson(data).toString())));
  }

  void searchForNewAlarms(){
    channel.sink.add(globals.getAlarmsRequest);
  }

  @override
  void dispose(){
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for Alarms'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Column(
              children: list.map((e) => Text(e)).toList(),
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: (){
          searchForNewAlarms();
        }
      ),
    );
  }
}

