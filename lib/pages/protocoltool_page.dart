import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:saferfire/constants.dart';

const _mainColor = Color(0xFFbb1e10);

class ProtocolPage extends StatefulWidget {
  const ProtocolPage({super.key});

  @override
  _ProtocolPageState createState() => _ProtocolPageState();
}

class _ProtocolPageState extends State<ProtocolPage> {
  late Timer _dialogTimer;
  // Technisch
  int tiereGerettetTechnisch = 0;
  int tiereTotTechnisch = 0;

  TextEditingController _ursacheController = new TextEditingController();
  TextEditingController _hautTaetigkeitController = new TextEditingController();
  TextEditingController _gefaehrlicheStoffeController =
  new TextEditingController();
  TextEditingController _weiterTaetigkeitenController =
  new TextEditingController();

  // Brand
  int tiereGerettetBrand = 0;
  int tiereTotBrand = 0;

  TextEditingController _entdeckungController = new TextEditingController();
  TextEditingController _ausmassController = new TextEditingController();
  TextEditingController _klasseController = new TextEditingController();
  TextEditingController _brandController = new TextEditingController();
  TextEditingController _objektartController = new TextEditingController();
  TextEditingController _bauartController = new TextEditingController();
  TextEditingController _lageController = new TextEditingController();
  TextEditingController _verlaufController = new TextEditingController();
  List<String> entdeckungItems = ['Test 1', 'Test 2'];
  String? selectedEntdeckung = 'Test 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], //Color(0xFFf2f6f8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      left: 20.0, top: 40.0, bottom: 20.0),
                  child: Text(
                    "Protokoll ${showingAlarmId + 1}/${protocols.length}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, bottom: 10.0),
                      child: const Text("Fotos hinzufügen",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: _mainColor)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child:
                        const Icon(Icons.add_a_photo_outlined, size: 45.0),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _mainColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: const Icon(Icons.add_photo_alternate_outlined,
                            size: 50.0),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _mainColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 3),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0),
                          child: const Text("Grunddaten",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: _mainColor)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: _mainColor,
                              size: 30.0,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    insetPadding: const EdgeInsets.only(left: 2, right: 2),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10.0, top: 10.0, bottom: 10.0),
                                                child: const Text("Grunddaten",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 25,
                                                        color: _mainColor)),
                                              ),
                                            ]),
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
                                                  "${protocols.elementAt(showingAlarmId).einstznummer}",
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 25),
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
                                                  "${protocols.elementAt(showingAlarmId).leitstellenJahr?.year}",
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 25),
                                                ),
                                                //Text("Einsatznummer: ${widget.protocol!.einstznummer}"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Kategorie',
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        if (protocols.elementAt(showingAlarmId).alarmart == 'BRAND')
                                          const Text(
                                            "BRAND",
                                            style: TextStyle(color: Colors.black, fontSize: 25),
                                          ),
                                        if (protocols.elementAt(showingAlarmId).alarmart != 'BRAND')
                                          const Text(
                                            "TECHNISCH",
                                            style: TextStyle(color: Colors.black, fontSize: 25),
                                          ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Straße',
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "${protocols.elementAt(showingAlarmId).strasse}",
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 25),
                                        ),
                                        Text(
                                          "${protocols.elementAt(showingAlarmId).koordinaten}",
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Alarmart',
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "${protocols.elementAt(showingAlarmId).alarmart}",
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("ZURÜCK", style: TextStyle(fontWeight:FontWeight.normal,fontSize: 20,color:_mainColor))),
                                    ],
                                  ));
                            },
                          ),
                        ),
                      ]),
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
                            "${protocols.elementAt(showingAlarmId).einstznummer}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 25),
                          ),
                          //Text("Einsatznummer: ${widget.protocol!.einstznummer}"),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            'Kategorie',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (protocols.elementAt(showingAlarmId).alarmart == 'BRAND')
                            const Text(
                              "BRAND",
                              style: TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          if (protocols.elementAt(showingAlarmId).alarmart != 'BRAND')
                            const Text(
                              "TECHNISCH",
                              style: TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0),
                          child: const Text("Stammdaten",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: _mainColor)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: _mainColor,
                              size: 30.0,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text("Zeiten ändern",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 25,
                                                  color: _mainColor)),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: Builder(
                                              builder: (context) =>
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      TimeOfDay? newTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                          TimeOfDay
                                                              .now());
                                                      if (newTime == null)
                                                        return;
                                                      setState(() => protocols
                                                          .elementAt(
                                                          showingAlarmId)
                                                          .uhrzeitAusfahrt =
                                                          newTime);
                                                    },
                                                    minWidth: 100,
                                                    color: mainColor,
                                                    textColor: Colors.black,
                                                    child: const Text(
                                                        "Ausfahrt",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .normal,
                                                            fontSize: 20,
                                                            color:
                                                            Colors.white)),
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10,
                                                        top: 20,
                                                        right: 10,
                                                        bottom: 20),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      //side: BorderSide(color: Colors.red)
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: Builder(
                                              builder: (context) =>
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      TimeOfDay? newTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                          TimeOfDay
                                                              .now());
                                                      if (newTime == null)
                                                        return;
                                                      setState(() => protocols
                                                          .elementAt(
                                                          showingAlarmId)
                                                          .uhrzeitAusfahrt =
                                                          newTime);
                                                    },
                                                    minWidth: 100,
                                                    color: mainColor,
                                                    textColor: Colors.black,
                                                    child: const Text("Ankunft",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .normal,
                                                            fontSize: 20,
                                                            color:
                                                            Colors.white)),
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10,
                                                        top: 20,
                                                        right: 10,
                                                        bottom: 20),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      //side: BorderSide(color: Colors.red)
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: Builder(
                                              builder: (context) =>
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      TimeOfDay? newTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                          TimeOfDay
                                                              .now());
                                                      if (newTime == null)
                                                        return;
                                                      setState(() => protocols
                                                          .elementAt(
                                                          showingAlarmId)
                                                          .uhrzeitEnde =
                                                          newTime);
                                                    },
                                                    minWidth: 100,
                                                    color: mainColor,
                                                    textColor: Colors.black,
                                                    child: const Text(
                                                        "Einsatzende",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .normal,
                                                            fontSize: 20,
                                                            color:
                                                            Colors.white)),
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10,
                                                        top: 20,
                                                        right: 10,
                                                        bottom: 20),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      //side: BorderSide(color: Colors.red)
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: Builder(
                                              builder: (context) =>
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      TimeOfDay? newTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                          TimeOfDay
                                                              .now());
                                                      if (newTime == null)
                                                        return;
                                                      setState(() => protocols
                                                          .elementAt(
                                                          showingAlarmId)
                                                          .uhrzeitWiederbereit =
                                                          newTime);
                                                    },
                                                    minWidth: 100,
                                                    color: mainColor,
                                                    textColor: Colors.black,
                                                    child: const Text(
                                                        "Wiedereinsatzbereit",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .normal,
                                                            fontSize: 20,
                                                            color:
                                                            Colors.white)),
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10,
                                                        top: 20,
                                                        right: 10,
                                                        bottom: 20),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      //side: BorderSide(color: Colors.red)
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ]),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("ZURÜCK", style: TextStyle(fontWeight:FontWeight.normal,fontSize: 20,color:_mainColor))),
                                    ],
                                  ));
                            },
                          ),
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          MaterialButton(
                            onPressed: () {
                              protocols
                                  .elementAt(showingAlarmId)
                                  .uhrzeitAusfahrt = TimeOfDay.now();
                              setState(() {});
                            },
                            minWidth: 100,
                            color: mainColor,
                            textColor: Colors.black,
                            child: protocols
                                .elementAt(showingAlarmId)
                                .uhrzeitAusfahrt ==
                                null
                                ? Column(
                              children: const [
                                Text("Ausfahrt",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                                : Column(
                              children: [
                                const Text("Ausfahrt",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.white)),
                                Text(
                                    "${protocols.elementAt(showingAlarmId).uhrzeitAusfahrt?.hour}:${protocols.elementAt(showingAlarmId).uhrzeitAusfahrt?.minute}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20)),
                              ],
                            ),
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, right: 10, bottom: 20),
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
                              //() => entries[index].isDone == false ? _promptClickSquad(index): _promptClickDoneSquad(index)
                              if (protocols
                                  .elementAt(showingAlarmId)
                                  .uhrzeitAusfahrt !=
                                  null) {
                                protocols
                                    .elementAt(showingAlarmId)
                                    .uhrzeitAnkunft = TimeOfDay.now();
                                setState(() {});
                              }
                            },
                            minWidth: 100,
                            color: protocols
                                .elementAt(showingAlarmId)
                                .uhrzeitAusfahrt ==
                                null
                                ? Colors.grey
                                : mainColor,
                            textColor: Colors.black,
                            child: protocols
                                .elementAt(showingAlarmId)
                                .uhrzeitAnkunft ==
                                null
                                ? Column(
                              children: const [
                                Text("Ankunft",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                                : Column(
                              children: [
                                const Text("Ankunft",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.white)),
                                Text(
                                    "${protocols.elementAt(showingAlarmId).uhrzeitAnkunft?.hour}:${protocols.elementAt(showingAlarmId).uhrzeitAnkunft?.minute}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20)),
                              ],
                            ),
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, right: 10, bottom: 20),
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
                              if (protocols
                                  .elementAt(showingAlarmId)
                                  .uhrzeitAnkunft !=
                                  null) {
                                protocols
                                    .elementAt(showingAlarmId)
                                    .uhrzeitEnde = TimeOfDay.now();
                                setState(() {});
                              }
                            },
                            minWidth: 100,
                            color: protocols
                                .elementAt(showingAlarmId)
                                .uhrzeitAnkunft ==
                                null
                                ? Colors.grey
                                : mainColor,
                            textColor: Colors.black,
                            child: protocols
                                .elementAt(showingAlarmId)
                                .uhrzeitEnde ==
                                null
                                ? Column(
                              children: const [
                                Text("Einsatzende",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                                : Column(
                              children: [
                                const Text("Einsatzende",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.white)),
                                Text(
                                    "${protocols.elementAt(showingAlarmId).uhrzeitEnde?.hour}:${protocols.elementAt(showingAlarmId).uhrzeitEnde?.minute}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20)),
                              ],
                            ),
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, right: 10, bottom: 20),
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
                            onPressed: () {
                              //() => entries[index].isDone == false ? _promptClickSquad(index): _promptClickDoneSquad(index)
                              if (protocols
                                  .elementAt(showingAlarmId)
                                  .uhrzeitEnde !=
                                  null) {
                                protocols
                                    .elementAt(showingAlarmId)
                                    .uhrzeitWiederbereit = TimeOfDay.now();
                                setState(() {});
                              }
                            },
                            minWidth: 100,
                            color: protocols
                                .elementAt(showingAlarmId)
                                .uhrzeitEnde ==
                                null
                                ? Colors.grey
                                : mainColor,
                            textColor: Colors.black,
                            child: protocols
                                .elementAt(showingAlarmId)
                                .uhrzeitWiederbereit ==
                                null
                                ? Column(
                              children: const [
                                Text("Wiedereinsatzbereit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: Colors.white)),
                                Text(
                                  "JETZT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                                : Column(
                              children: [
                                const Text("Wiedereinsatzbereit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.white)),
                                Text(
                                    "${protocols.elementAt(showingAlarmId).uhrzeitWiederbereit?.hour}:${protocols.elementAt(showingAlarmId).uhrzeitWiederbereit?.minute}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20)),
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
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 10.0, bottom: 10.0),
                      child: const Text("Personen",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: _mainColor)),
                    ),
                  ),
                  viewTiere(),
                ],
              ),
            ),
            if (protocols.elementAt(showingAlarmId).alarmart == 'BRAND')
              Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0),
                        child: const Text("Brand Statistik",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: _mainColor)),
                      ),
                    ),
                    brandViewStatistik()
                  ],
                ),
              ),
            if (protocols.elementAt(showingAlarmId).alarmart != 'BRAND')
              Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0),
                        child: const Text("Technische Statistik",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: _mainColor)),
                      ),
                    ),
                    technischViewStatistik(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget viewTiere() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('gerettet', style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 6),
        NumberPicker(
          value: protocols.elementAt(showingAlarmId).tiereGerettet,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) => setState(
                  () => protocols.elementAt(showingAlarmId).tiereGerettet = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(height: 20),
        Text('tot geborgen', style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 6),
        NumberPicker(
          value: protocols.elementAt(showingAlarmId).tiereTot,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) => setState(
                  () => protocols.elementAt(showingAlarmId).tiereTot = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget technischViewStatistik() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Ursache"),
                TextField(
                    controller: _ursacheController,
                    decoration: InputDecoration(
                      labelText: protocols.elementAt(showingAlarmId).ursache,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Haupt-Tätigkeit"),
                TextField(
                    controller: _hautTaetigkeitController,
                    decoration: InputDecoration(
                      labelText:
                      protocols.elementAt(showingAlarmId).hauptTaetigkeit,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Gefährliche Stoffe"),
                TextField(
                    controller: _gefaehrlicheStoffeController,
                    decoration: InputDecoration(
                      labelText: protocols
                          .elementAt(showingAlarmId)
                          .gerfaehrlicheStoffe,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Weitere Tätigkeiten"),
                TextField(
                    controller: _weiterTaetigkeitenController,
                    decoration: InputDecoration(
                      labelText: protocols
                          .elementAt(showingAlarmId)
                          .weiterTaetigkeiten,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    protocols.elementAt(showingAlarmId).ursache =
                        _ursacheController.text;
                    protocols.elementAt(showingAlarmId).hauptTaetigkeit =
                        _hautTaetigkeitController.text;
                    protocols.elementAt(showingAlarmId).gerfaehrlicheStoffe =
                        _gefaehrlicheStoffeController.text;
                    protocols.elementAt(showingAlarmId).weiterTaetigkeiten =
                        _weiterTaetigkeitenController.text;
                    FocusScope.of(context).unfocus();
                    showDialog(
                        context: context,
                        builder: (BuildContext builderContext) {
                          _dialogTimer = Timer(const Duration(seconds: 1), () {
                            Navigator.of(context).pop();
                          });

                          return const AlertDialog(
                            backgroundColor: Colors.red,
                            title: Text('Protokoll wird gespeichert',style: TextStyle(color: Colors.white),),
                          );
                        }
                    ).then((val){
                      if (_dialogTimer.isActive) {
                        _dialogTimer.cancel();
                      }
                    });
                  },
                  child: const Text("Speichern"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget brandViewStatistik() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                const Text("Brand - Ausmaß"),
                TextField(
                    controller: _ausmassController,
                    decoration: InputDecoration(
                      labelText:
                      protocols.elementAt(showingAlarmId).brandAusmass,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Brand - Klasse"),
                TextField(
                    controller: _klasseController,
                    decoration: InputDecoration(
                      labelText:
                      protocols.elementAt(showingAlarmId).brandKlasse,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Brand"),
                TextField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      labelText: protocols.elementAt(showingAlarmId).brand,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Objektart"),
                TextField(
                    controller: _objektartController,
                    decoration: InputDecoration(
                      labelText: protocols.elementAt(showingAlarmId).objektart,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Brand - Bauart"),
                TextField(
                    controller: _bauartController,
                    decoration: InputDecoration(
                      labelText:
                      protocols.elementAt(showingAlarmId).brandBauart,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Brand - Lage"),
                TextField(
                    controller: _lageController,
                    decoration: InputDecoration(
                      labelText: protocols.elementAt(showingAlarmId).brandLage,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                const Text("Brand - Verlauf"),
                TextField(
                    controller: _verlaufController,
                    decoration: InputDecoration(
                      labelText:
                      protocols.elementAt(showingAlarmId).brandVerlauf,
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    protocols.elementAt(showingAlarmId).brandEndeckung =
                        selectedEntdeckung;
                    protocols.elementAt(showingAlarmId).brandAusmass =
                        _ausmassController.text;
                    protocols.elementAt(showingAlarmId).brandKlasse =
                        _klasseController.text;
                    protocols.elementAt(showingAlarmId).brand =
                        _brandController.text;
                    protocols.elementAt(showingAlarmId).objektart =
                        _objektartController.text;
                    protocols.elementAt(showingAlarmId).brandBauart =
                        _bauartController.text;
                    protocols.elementAt(showingAlarmId).brandLage =
                        _lageController.text;
                    protocols.elementAt(showingAlarmId).brandVerlauf =
                        _verlaufController.text;
                  },
                  child: const Text("Speichern"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
      //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color: Color(0xffbfbfbf),
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color: mainColor,
          width: 3,
        ));
  }
}