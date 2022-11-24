import 'package:flutter/material.dart';
import 'package:saferfire/camerafunction.dart';
import 'package:saferfire/constants.dart';
import 'package:saferfire/views/grundinformationen_view.dart';
import 'package:saferfire/models/Protocol.dart';



const _mainColor = Color(0xFFbb1e10);

class ProtocolPage extends StatelessWidget {
  Protocol? newProtocol;
  bool isTechnisch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Protokoll erstellen'),
        // ),
        body: isProtocol? showProtocol(context) : noProtocol(context)
    );
  }

  Widget noProtocol(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Protokoll",
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black),
          ),
          const Text(
            "erstellen",
            style: TextStyle(fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.black),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            child: const Icon(Icons.add, size: 50.0),
            onPressed: () {
              newProtocol = Protocol(
                  alarms.elementAt(0).Id, alarms.elementAt(0).Type, alarms.elementAt(0).Address,
                  "${alarms.elementAt(0).Lat} + ${alarms.elementAt(0).Lng}", alarms.elementAt(0).AlarmType, DateTime.now());
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      GrundinformationenView(protocol: newProtocol,))
              );
            },
            style: ElevatedButton.styleFrom(
                primary: _mainColor,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Icon(Icons.add_a_photo_outlined, size: 45.0),
                onPressed: () {
                  openCamera();
                },
                style: ElevatedButton.styleFrom(
                    primary: _mainColor.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: Icon(Icons.add_photo_alternate_outlined, size: 50.0),
                onPressed: () {
                  openGallery();
                },
                style: ElevatedButton.styleFrom(
                    primary: _mainColor.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*Column(
  children: [
  new Container(
  margin: const EdgeInsets.only(top: 80),
  child: Column(
  children: [
  Align(
  alignment: Alignment.center,
  // Align however you like (i.e .centerRight, centerLeft)
  child: Column(
  children: <Widget>[
  Text(
  "Protokoll",
  style: TextStyle(fontWeight: FontWeight.bold,
  fontSize: 20,
  color: Colors.black),
  ),
  Text(
  "erstellen",
  style: TextStyle(fontWeight: FontWeight.normal,
  fontSize: 18,
  color: Colors.black),
  ),
  ]
  ),
  ),
  const SizedBox(height: 15),
  ElevatedButton(
  child: Icon(Icons.add, size: 50.0),
  onPressed: () {
  newProtocol = new Protocol(
  alarms.first.Id, alarms.first.Type, alarms.first.Address,
  "${alarms.first.Lat} + ${alarms.first.Lng}", alarms.first.AlarmType, DateTime.now());
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) =>
  GrundinformationenView(protocol: newProtocol,))
  );
  },
  style: ElevatedButton.styleFrom(
  primary: _mainColor,
  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
  textStyle: TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold)),
  ),
  ],
  ),
  ),
  /*const SizedBox(height: 15),
        Text(
          "Notizen",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black54),
        ),
        Divider(
            height: 20,
            thickness: 2,
            color: Colors.black54
        ),*/
  ],
  );*/

  Widget showProtocol(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.center,
                    // Align however you like (i.e .centerRight, centerLeft)
                    child: Text(
                      "Protokoll",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: _mainColor),
                    ),
                  ),
                  Divider(
                    height: 80,
                    thickness: 2,
                    color: mainColor,
                  ),
                  Column(
                    children: [
                      const Text("Einsatznummer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
                      Text("${protocol.einstznummer}", style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 10),
                      const Text("Kategorie", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
                      Text("${protocol!.kategorie!.split(' ')[0]}", style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 20),
                      const Text("Stammdaten", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: _mainColor)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text("Ausfahrt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
                              Text("${protocol.uhrzeitAusfahrt?.hour}:${protocol.uhrzeitAusfahrt?.minute}", style: const TextStyle(fontSize: 25)),
                            ],
                          ),
                          const SizedBox(width: 40),
                          Column(
                            children: [
                              const Text("Ankunft", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
                              Text("${protocol.uhrzeitAnkunft?.hour}:${protocol.uhrzeitAnkunft?.minute}", style: const TextStyle(fontSize: 25)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text("Wiederbereit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
                              Text("${protocol.uhrzeitWiederbereit?.hour}:${protocol.uhrzeitWiederbereit?.minute}", style: const TextStyle(fontSize: 25)),
                            ],
                          ),
                          const SizedBox(width: 40),
                          Column(
                            children: [
                              const Text("Ende", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
                              Text("${protocol.uhrzeitEnde?.hour}:${protocol.uhrzeitEnde?.minute}", style: const TextStyle(fontSize: 25)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    child: const Text("Statistik"),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                backgroundColor: mainColor,
                                title: const Text('Statistik'),
                              ),
                              body: protocol.isTechnisch? ProtokollStatistikTechnisch() : ProtokollStatistikBrand(),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: mainColor,
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Text(
            //   "Kommentare",
            //   style: TextStyle(fontWeight: FontWeight.w500,
            //       fontSize: 20,
            //       color: Colors.grey),
            // ),
            // Divider(
            //     height: 20,
            //     thickness: 2,
            //     color: Colors.grey
            // ),
          ],
        )
    );
  }
}

class ProtokollStatistikTechnisch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(protocol!.kategorie!.split(' ')[0], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Divider(
            height: 60,
            thickness: 2,
            color: mainColor,
          ),
          const Text("Ursache", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.ursache}", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          const Text("Haupt - Tätigkeit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.hauptTaetigkeit}", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          const Text("Gefährliche Stoffe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.gerfaehrlicheStoffe}", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          const Text("weiter Tätigkeiten", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.weiterTaetigkeiten}", style: const TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}

class ProtokollStatistikBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(protocol!.kategorie!.split(' ')[0], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Divider(
            height: 60,
            thickness: 2,
            color: mainColor,
          ),
          const Text("Endeckung", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.brandEndeckung}", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          const Text("Ausmass", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.brandAusmass}", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          const Text("Brand", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.brand}", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          const Text("Objektart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.objektart}", style: const TextStyle(fontSize: 30)),
          const Text("Bauart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.brandBauart}", style: const TextStyle(fontSize: 30)),
          const Text("Lage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.brandLage}", style: const TextStyle(fontSize: 30)),
          const Text("Verlauf", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _mainColor)),
          Text("${protocol.brandVerlauf}", style: const TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}

/*
//Brand - Statistik
  String? brandEndeckung;
  String? brandAusmass;
  String? brandKlasse;
  String? brand;
  String? objektart;
  String? brandBauart;
  String? brandLage;
  String? brandVerlauf;

*/

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
