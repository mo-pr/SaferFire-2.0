import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:saferfire/constants.dart';

const _mainColor = Color(0xFFbb1e10);

class ProtocolPage2 extends StatefulWidget {
  const ProtocolPage2({super.key});

  @override
  _ProtocolPage2State createState() => _ProtocolPage2State();
}

class _ProtocolPage2State extends State<ProtocolPage2> {
  int tiereGerettet = 0;
  int tiereTot = 0;

  TextEditingController _ursacheController = new TextEditingController();
  TextEditingController _hautTaetigkeitController = new TextEditingController();
  TextEditingController _gefaehrlicheStoffeController = new TextEditingController();
  TextEditingController _weiterTaetigkeitenController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],//Color(0xFFf2f6f8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 20.0, top: 40.0, bottom: 20.0),
                  child: const Text(
                    "Protokoll",
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: _mainColor),
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                      child: const Text("Fotos hinzufügen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: _mainColor)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Icon(Icons.add_a_photo_outlined, size: 45.0),
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _mainColor,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: const Icon(Icons.add_photo_alternate_outlined, size: 50.0),
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _mainColor,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                            textStyle: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                      child: const Text("Grunddaten", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: _mainColor)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Einsatznummer',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${protocol.einstznummer}",
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                          ),
                          //Text("Einsatznummer: ${widget.protocol!.einstznummer}"),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            'Leitstellenjahr',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${protocol.leitstellenJahr?.year}",
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                          ),
                          //Text("Einsatznummer: ${widget.protocol!.einstznummer}"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Kategorie',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "${protocol.kategorie?.split(' ')[0]}",
                    style: const TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                      child: const Text("Stammdaten", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: _mainColor)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          MaterialButton(
                            onPressed: () {
                              protocol.uhrzeitAusfahrt = TimeOfDay.now();
                              setState(() {});
                            },
                            minWidth: 100,
                            color: mainColor,
                            textColor: Colors.black,
                            child: protocol.uhrzeitAusfahrt == null ? Column(
                              children: const [
                                Text("Ausfahrt", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ) : Column(
                              children: [
                                const Text("Ausfahrt", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white)),
                                Text("${protocol.uhrzeitAusfahrt?.hour}:${protocol.uhrzeitAusfahrt?.minute}", style: const TextStyle(color: Colors.white, fontSize: 20)),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              //side: BorderSide(color: Colors.red)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          MaterialButton(
                            onPressed: () { //() => entries[index].isDone == false ? _promptClickSquad(index): _promptClickDoneSquad(index)
                              if(protocol.uhrzeitAusfahrt != null){
                                protocol.uhrzeitAnkunft = TimeOfDay.now();
                                setState(() {});
                              }
                            },
                            minWidth: 100,
                            color: protocol.uhrzeitAusfahrt == null ? Colors.grey : mainColor,
                            textColor: Colors.black,
                            child: protocol.uhrzeitAnkunft == null ? Column(
                              children: const [
                                Text("Ankunft", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ) : Column(
                              children: [
                                const Text("Ankunft", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white)),
                                Text("${protocol.uhrzeitAnkunft?.hour}:${protocol.uhrzeitAnkunft?.minute}", style: const TextStyle(color: Colors.white, fontSize: 20)),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              //side: BorderSide(color: Colors.red)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          MaterialButton(
                            onPressed: () {
                              if(protocol.uhrzeitAnkunft != null){
                                protocol.uhrzeitEnde = TimeOfDay.now();
                                setState(() {});
                              }
                            },
                            minWidth: 100,
                            color:  protocol.uhrzeitAnkunft == null ? Colors.grey : mainColor,
                            textColor: Colors.black,
                            child: protocol.uhrzeitEnde == null ? Column(
                              children: const [
                                Text("Einsatzende", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ) : Column(
                              children: [
                                const Text("Einsatzende", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white)),
                                Text("${protocol.uhrzeitEnde?.hour}:${protocol.uhrzeitEnde?.minute}", style: const TextStyle(color: Colors.white, fontSize: 20)),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              //side: BorderSide(color: Colors.red)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                         MaterialButton(
                            onPressed: () { //() => entries[index].isDone == false ? _promptClickSquad(index): _promptClickDoneSquad(index)
                              if(protocol.uhrzeitEnde != null){
                                protocol.uhrzeitWiederbereit = TimeOfDay.now();
                                setState(() {});
                              }
                            },
                            minWidth: 100,
                            color: protocol.uhrzeitEnde == null ? Colors.grey : mainColor,
                            textColor: Colors.black,
                            child: protocol.uhrzeitWiederbereit == null ? Column(
                              children: const [
                                Text("Wiedereinsatzbereit", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ) : Column(
                              children: [
                                const Text("Wiedereinsatzbereit", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white)),
                                Text("${protocol.uhrzeitWiederbereit?.hour}:${protocol.uhrzeitWiederbereit?.minute}", style: const TextStyle(color: Colors.white, fontSize: 20)),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              //side: BorderSide(color: Colors.red)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                      child: const Text("Technische Statistik", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: _mainColor)),
                    ),
                  ),
                  technischViewTiere(),
                  technischViewStatistik(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget technischViewTiere() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Tiere',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        const SizedBox(height: 30),
        Text('gerettet', style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 6),
        NumberPicker(
          value: protocol.tiereGerettet,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) =>
              setState(() => protocol.tiereGerettet = value),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(height: 20),
        Text('tot geborgen', style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 6),
        NumberPicker(
          value: protocol.tiereTot,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) =>
              setState(() => protocol.tiereTot = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        Divider(
            height: 50,
            thickness: 2,
            color: mainColor
        ),
      ],
    );
  }

  @override
  Widget technischViewStatistik() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Teschnische Statistik',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                    controller: _ursacheController,
                    decoration: InputDecoration(
                      labelText: protocol.ursache,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _hautTaetigkeitController,
                    decoration: InputDecoration(
                      labelText: protocol.hauptTaetigkeit,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _gefaehrlicheStoffeController,
                    decoration: InputDecoration(
                      labelText: protocol.gerfaehrlicheStoffe,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _weiterTaetigkeitenController,
                    decoration: InputDecoration(
                      labelText: protocol.weiterTaetigkeiten,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (){
                    protocol.ursache = _ursacheController.text;
                    protocol.hauptTaetigkeit = _hautTaetigkeitController.text;
                    protocol.gerfaehrlicheStoffe = _gefaehrlicheStoffeController.text;
                    protocol.weiterTaetigkeiten = _weiterTaetigkeitenController.text;},
                  child: const Text("Speichern"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder( //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color:Colors.white,
          width: 3,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color: mainColor,
          width: 3,
        )
    );
  }
}


