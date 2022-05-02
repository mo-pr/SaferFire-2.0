import 'package:flutter/material.dart';
import 'package:saferfire/constants.dart';
import 'package:saferfire/views/grundinformationen_view.dart';
import 'package:saferfire/models/Protocol.dart';


class ProtocolPage extends StatelessWidget {
  Protocol? newProtocol;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Protokoll erstellen'),
        ),
        body: isProtocol? showProtocol(context) : noProtocol(context)
    );
  }

  Widget noProtocol(BuildContext context) {
    return Column(
      children: [
        new Container(
          margin: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                // Align however you like (i.e .centerRight, centerLeft)
                child: Text(
                  "Es wurde noch kein Protokoll erstellt",
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                child: Icon(Icons.add, size: 50.0),
                onPressed: () {
                  newProtocol = new Protocol(
                      alarms.first.Id, alarms.first.Type, alarms.first.Address,
                      "${alarms.first.Lat} + ${alarms.first.Lng}", alarms.first.AlarmType);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          GrundinformationenView(protocol: newProtocol,))
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Kommentare",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey),
        ),
        Divider(
            height: 20,
            thickness: 2,
            color: Colors.grey
        ),
      ],
    );
  }

  Widget showProtocol(BuildContext context) {
    return Center(
        child: Column(
          children: [
            new Container(
              margin: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    // Align however you like (i.e .centerRight, centerLeft)
                    child: Text(
                      "Protokoll wurde erstellt",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text("${protocol.einstznummer}"),
                  const SizedBox(height: 15),
                  Text("${protocol.kategorie}"),
                  const SizedBox(height: 15),
                  Text("${protocol.ursache}"),
                  const SizedBox(height: 15),
                  Text("..."),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Kommentare",
              style: TextStyle(fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            Divider(
                height: 20,
                thickness: 2,
                color: Colors.grey
            ),
          ],
        )
    );
  }
}


class Grundinformationen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Protokoll"),
      ),
      body: Container(
        child: Text("Grundinformationen"),
      ),
    );
  }
}
