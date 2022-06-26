import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;

List<PDFEntry> persEntries = <PDFEntry>[];
List<Entry> entries = <Entry>[];

class OxygenPage extends StatefulWidget {
  @override
  _OxygenPageState createState() => _OxygenPageState();
}

class _OxygenPageState extends State<OxygenPage> {
  late Timer _timer;
  TextEditingController _controller01 = new TextEditingController();
  TextEditingController _controller02 = new TextEditingController();
  TextEditingController _controller03 = new TextEditingController();
  TextEditingController _pressure01 = new TextEditingController();
  TextEditingController _pressure02 = new TextEditingController();
  TextEditingController _pressure03 = new TextEditingController();

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void handleStartStop(int index) {
    if (entries[index]._timer.isRunning) {
      entries[index]._timer.stop();
      persEntries[index]._stoptime = DateTime.now();
    } else {
      entries[index]._timer.start();
      entries[index]._time = DateFormat('kk:mm:ss').format(DateTime.now()).toString();
      persEntries[index]._starttime = DateTime.now();
    }
    setState(() {});
  }

  void _promptClickSquad(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Center(child: Text("Trupp " + (index + 1).toString() + ": Wählen Sie eine Aktion")),
              content: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new FlatButton(
                        child: new Text('Start - Stop'),
                        onPressed: () {
                          handleStartStop(index);
                          Navigator.of(context).pop();
                        }),
                    new FlatButton(
                        child: new Text('isDone'),
                        onPressed: () {
                          entries[index]._timer.stop();
                          entries[index].isDone = true;
                          Navigator.of(context).pop();
                        }) // button 2
                  ]
              ),
          );
        });
  }

  void _promptClickDoneSquad(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Center(child: Text("Trupp " + (index + 1).toString())),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children : <Widget>[
                  Expanded(
                    child: Text(
                      "Einsatz wurde beendet",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2f6f8),
      appBar: AppBar(
        title: const Text('Atemschutz'),
      ),
      body: Center(
        child: entries.isEmpty == true
            ? Container(
          child: Text(
            "Keine Trupp vorhanden",
            style: TextStyle(color: Colors.black87, fontSize: 28),
          ),
        )
            : ListView.builder(
            padding: const EdgeInsets.only(left: 8, right: 8, top:40, bottom: 8),
            scrollDirection: Axis.vertical,
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
               onTap: () => entries[index].isDone == false ? _promptClickSquad(index): _promptClickDoneSquad(index),
                child: Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Card(
                      color: entries[index].isDone == false ? Colors.white : Colors.grey,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFFd7dfe4), width: 2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Trupp:",
                                    style: TextStyle(
                                        fontSize: 19.0, color: Colors.black87),
                                  ),
                                  Text(
                                    entries[index].entryNr.toString(),
                                    style: TextStyle(
                                        fontSize: 19.0, color: Colors.black87),
                                  ),
                                ],
                              ),
                              Text(
                                formatTime(entries[index]
                                    ._timer
                                    .elapsedMilliseconds),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                entries[index]._getNames(),
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.green),
                              ),
                            ],
                          )),
                    )),
              );
            }),
      ),
      floatingActionButton: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(2.0),
        child: InkWell(
          onTap: () {
            _controller01.clear();
            _controller02.clear();
            _controller03.clear();
            _pressure01.clear();
            _pressure02.clear();
            _pressure03.clear();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: contentBox(context),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(0.0),
            height: 80.0,
            //MediaQuery.of(context).size.width * .08,
            width: MediaQuery.of(context).size.width * .92,
            //MediaQuery.of(context).size.width * .3,
            decoration: BoxDecoration(
              color: Color(0xFF97170b),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              children: <Widget>[
                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: Color(0xFFA81A0D),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  );
                }),
                const Expanded(
                  child: Text(
                    'Einsatztrupp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {
          _controller01.clear();
          _controller02.clear();
          _controller03.clear();
          _pressure01.clear();
          _pressure02.clear();
          _pressure03.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.padding),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: contentBox(context),
              );
            },
          );
        },
      ),*/
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Neuer Trupp",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Person 1"),
                controller: _controller01,
              ),
              SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Person 2"),
                controller: _controller02,
              ),
              SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Person 3"),
                controller: _controller03,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(Constants.padding),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: pressureBox(context),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Speichern",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              //child: Image.asset("assets/images/logo_small_icon_only_inverted.png")
            ),
          ),
        ),
      ],
    );
  }

  pressureBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Sauerstoff",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Druck Person 1 "),
                controller: _pressure01,
              ),
              SizedBox(
                height: 4,
              ),
              (_controller02.text != "")
                  ? TextField(
                decoration: InputDecoration(hintText: "Druck Person 2"),
                controller: _pressure02,
              )
                  : Container(),
              SizedBox(
                height: 4,
              ),
              (_controller03.text != "")
                  ? TextField(
                decoration: InputDecoration(hintText: "Druck Person 3"),
                controller: _pressure03,
              )
                  : Container(),
              SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () {
                      if (_controller01.text != "") {
                        setState(() {
                          DateTime now = new DateTime.now();
                          entries.add(new Entry(
                              _controller01.text,
                              _controller02.text,
                              _controller03.text,
                              entries.length + 1));
                          persEntries.add(new PDFEntry(
                              _controller01.text,
                              _controller02.text,
                              _controller03.text,
                              entries.length));
                          entries[entries.length - 1]._pressure01 =
                              _pressure01.text;
                          persEntries[entries.length - 1]._pressure01 =
                              _pressure01.text;
                          persEntries[entries.length-1]._people= 1;
                          if (_controller02.text != "") {
                            entries[entries.length - 1]._pressure02 =
                                _pressure02.text;
                          }
                          if (_controller02.text != "") {
                            persEntries[entries.length - 1]._pressure02 =
                                _pressure02.text;
                            persEntries[entries.length-1]._people= 2;
                          }
                          if (_controller03.text != "") {
                            entries[entries.length - 1]._pressure03 =
                                _pressure03.text;
                          }
                          if (_controller03.text != "") {
                            persEntries[entries.length - 1]._pressure03 =
                                _pressure03.text;
                            persEntries[entries.length-1]._people= 3;
                          }
                          _controller01.clear();
                          _controller02.clear();
                          _controller03.clear();
                          _pressure01.clear();
                          _pressure02.clear();
                          _pressure03.clear();
                          entries[entries.length - 1]._timer = Stopwatch();
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Speichern",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              //child: Image.asset("assets/images/logo_small_icon_only_inverted.png")
            ),
          ),
        ),
      ],
    );
  }
}

class Entry {
  late Stopwatch _timer;
  late int _entryNr;
  late String _person01;
  late String _person02;
  late String _person03;
  late String _time;
  bool isDone = false;

  late String _pressure01;
  late String _pressure02;
  late String _pressure03;

  Entry(_person01, _person02, _person03, _number) {
    this._person01 = _person01;
    this._person02 = _person02;
    this._person03 = _person03;
    this._entryNr = _number;
  }

  String _getNames() {
    String names = "";
    if(_person01.length >= 10){
      names += _person01[0] + _person01[1] + _person01[2] +_person01[3] +_person01[4] +_person01[5] + "..." + " - " + _pressure01 + " bar\n";
    }
    else {
      names += _person01 + " - " + _pressure01 + " bar\n";
    }

    if (!(_person02 == null || _person02 == "")) {
      if(_person02.length >= 10){
        names += _person02[0] + _person02[1] + _person02[2] +_person02[3] +_person02[4] +_person02[5] + "..." + " - " + _pressure02 + " bar\n";
      }
      else {
        names += _person02 + " - " + _pressure02 + " bar\n";
      }
    }
    if (!(_person03 == null || _person03 == "")) {
      if(_person03.length >= 10){
        names += _person03[0] + _person03[1] + _person03[2] +_person03[3] +_person03[4] +_person03[5] + "..." + " - " + _pressure03 + " bar\n";
      }
      else {
        names += _person03 + " - " + _pressure03 + " bar\n";
      }
    }

    return names;
  }

  String _getTime() {
    return _time;
  }

  int get entryNr => _entryNr;

  @override
  String toString() {
    return '$_time\n$_person01';
  }
}

class PDFEntry{
  late int _people;
  late int _entryNr;
  late String _person01;
  late String _person02;
  late String _person03;
  late DateTime _starttime;
  late DateTime _stoptime;
  late String _pressure01;
  late String _pressure02;
  late String _pressure03;

  PDFEntry(_person01, _person02, _person03, _number) {
    this._person01 = _person01;
    this._person02 = _person02;
    this._person03 = _person03;
    this._entryNr = _number;
    this._starttime = DateTime.now();
    this._stoptime = DateTime.now();
  }

  @override
  String toString() {
    switch(_people){
      case 1:
        return "Truppnr.: "+_entryNr.toString()+" von: "+_starttime.toIso8601String()+" bis: "+_stoptime.toIso8601String()+"\n("+_person01+" "+_pressure01+"bar)";
        break;
      case 2:
        return "Truppnr.: "+_entryNr.toString()+" von: "+_starttime.toIso8601String()+" bis: "+_stoptime.toIso8601String()+"\n("+_person01+" "+_pressure01+"bar) ""("+_person02+" "+_pressure02+"bar)";
        break;
      case 3:
        return "Truppnr.: "+_entryNr.toString()+" von: "+_starttime.toIso8601String()+" bis: "+_stoptime.toIso8601String()+"\n("+_person01+" "+_pressure01+"bar) ""("+_person02+" "+_pressure02+"bar) ""("+_person03+" "+_pressure03+"bar)";
        break;
    }
    return "";
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
