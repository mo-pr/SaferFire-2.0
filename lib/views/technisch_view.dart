import 'package:flutter/material.dart';
import 'package:saferfire/constants.dart';
import 'package:saferfire/models/Protocol.dart';
import 'package:saferfire/toolProtocol.dart';
import 'package:saferfire/views/stammdaten_view.dart';
import 'package:numberpicker/numberpicker.dart';

class TechnischView extends StatefulWidget{
  final Protocol? protocol;
  TechnischView({Key? key, @required this.protocol}) : super(key: key);

  @override
  _TechnischViewState createState() => _TechnischViewState();
}

class _TechnischViewState extends State<TechnischView> {
  int tiereGerettet = 0;
  int tiereTot = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Protokoll erstellen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tiere',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 30),
            Text('gerettet', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 6),
            NumberPicker(
              value: tiereGerettet,
              minValue: 0,
              maxValue: 100,
              step: 1,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: (value) =>
                  setState(() => tiereGerettet = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            SizedBox(height: 20),
            Text('tot geborgen', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 6),
            NumberPicker(
              value: tiereTot,
              minValue: 0,
              maxValue: 100,
              step: 1,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: (value) =>
                  setState(() => tiereTot = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            Divider(
                height: 50,
                thickness: 2,
                color: Colors.grey
            ),
            ElevatedButton(
              child: Text("Next"),
              onPressed: (){
                widget.protocol!.tiereGerettet = tiereGerettet;
                widget.protocol!.tiereTot = tiereTot;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Technisch_Statistik(protocol: widget.protocol))
                );
                //Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget counter(BuildContext context, int _currentValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16),
        Text('aus Gebäuden gerettet', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 6),
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) =>
              setState(() => _currentValue = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = _currentValue - 10;
                _currentValue = newValue.clamp(0, 100);
              }),
            ),
            Text('Current horizontal int value: $_currentValue'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = _currentValue + 10;
                _currentValue = newValue.clamp(0, 100);
              }),
            ),
          ],
        ),
      ],
    );
  }
}

class Technisch_Statistik extends StatefulWidget{
  final Protocol? protocol;
  Technisch_Statistik({Key? key, @required this.protocol}) : super(key: key);

  @override
  _Technisch_StatistikState createState() => _Technisch_StatistikState();
}

class _Technisch_StatistikState extends State<Technisch_Statistik> {
  TextEditingController _ursacheController = new TextEditingController();
  TextEditingController _hautTaetigkeitController = new TextEditingController();
  TextEditingController _gefaehrlicheStoffeController = new TextEditingController();
  TextEditingController _weiterTaetigkeitenController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Protokoll erstellen'),
      ),
      body: Scrollbar(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                  controller: _ursacheController,
                  decoration: InputDecoration(
                    labelText: "Ursache",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )
              ),
              const SizedBox(height: 10),
              TextField(
                  controller: _hautTaetigkeitController,
                  decoration: InputDecoration(
                    labelText: "Haupt-Tätigkeit",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )
              ),
              const SizedBox(height: 10),
              TextField(
                  controller: _gefaehrlicheStoffeController,
                  decoration: InputDecoration(
                    labelText: "Gefährliche Stoffe",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )
              ),
              const SizedBox(height: 10),
              TextField(
                  controller: _weiterTaetigkeitenController,
                  decoration: InputDecoration(
                    labelText: "Weitere Tätigkeiten",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )
              ),
              ElevatedButton(
                child: Text("Next"),
                onPressed: (){
                  widget.protocol!.ursache = _ursacheController.text;
                  widget.protocol!.hauptTaetigkeit = _hautTaetigkeitController.text;
                  widget.protocol!.gerfaehrlicheStoffe = _gefaehrlicheStoffeController.text;
                  widget.protocol!.weiterTaetigkeiten = _weiterTaetigkeitenController.text;
                  protocol = widget.protocol!;
                  isProtocol = true;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => TechnischView(protocol: widget.protocol))
                  // );
                  //Navigator.of(context).popUntil((route) => route.isFirst);
                  //  Navigator.pushAndRemoveUntil(
                  //      context,
                  //      MaterialPageRoute(builder: (BuildContext context) => ProtocolPage()),
                  //      ModalRoute.withName('/protocol') // Replace this with your root screen's route name (usually '/')
                  //  );
                  // //Navigator.popUntil(context, ModalRoute.withName('/protocol'));
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/protocol', (Route<dynamic> route) => false);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return OutlineInputBorder( //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color:Colors.white,
          width: 3,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color:Colors.greenAccent,
          width: 3,
        )
    );
  }

  Widget counter(BuildContext context, int _currentValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16),
        Text('aus Gebäuden gerettet', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 6),
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) =>
              setState(() => _currentValue = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = _currentValue - 10;
                _currentValue = newValue.clamp(0, 100);
              }),
            ),
            Text('Current horizontal int value: $_currentValue'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = _currentValue + 10;
                _currentValue = newValue.clamp(0, 100);
              }),
            ),
          ],
        ),
      ],
    );
  }
}