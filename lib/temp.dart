import 'package:flutter/material.dart';
import 'package:saferfire/main.dart';

/*class temp extends StatefulWidget{
  @override
  tempState createState() => tempState();
}*/

class tempState extends StatelessWidget {
  final List<String> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for Alarms'),
        backgroundColor: Colors.cyan,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CurrentAlarms()));
          }),
    );
  }
}
