import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';
import 'package:saferfire/views/stammdaten_view.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:saferfire/views/technisch_view.dart';

import '../constants.dart';
import '../infoPage.dart';

class BrandView extends StatefulWidget {
  final Protocol? protocol;

  BrandView({Key? key, @required this.protocol}) : super(key: key);

  @override
  _BrandViewState createState() => _BrandViewState();
}

class _BrandViewState extends State<BrandView> {
  int personenGebaeude = 0;
  int personenKraftfahrzeug = 0;
  int personenVerletzt = 0;
  int personenTot = 0;

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
              'Personen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 30),
            Text('aus Gebäuden gerettet',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 6),
            NumberPicker(
              value: personenGebaeude,
              minValue: 0,
              maxValue: 100,
              step: 1,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: (value) => setState(() => personenGebaeude = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            SizedBox(height: 20),
            Text('aus Kraftfahrzeugen gerettet',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 6),
            NumberPicker(
              value: personenKraftfahrzeug,
              minValue: 0,
              maxValue: 100,
              step: 1,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: (value) =>
                  setState(() => personenKraftfahrzeug = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            SizedBox(height: 20),
            Text('verletzt gerettet',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 6),
            NumberPicker(
              value: personenVerletzt,
              minValue: 0,
              maxValue: 100,
              step: 1,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: (value) => setState(() => personenVerletzt = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            SizedBox(height: 20),
            Text('tot geborgen', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 6),
            NumberPicker(
              value: personenTot,
              minValue: 0,
              maxValue: 100,
              step: 1,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: (value) => setState(() => personenTot = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            Divider(height: 50, thickness: 2, color: buttonColor),
            ElevatedButton(
              child: Text("Next"),
              onPressed: () {
                widget.protocol!.personenGebaeude = personenGebaeude;
                widget.protocol!.personenKraftfahrzeug = personenKraftfahrzeug;
                widget.protocol!.personenVerletzt = personenVerletzt;
                widget.protocol!.personenTot = personenTot;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            _Brand_TiereGerettet(protocol: widget.protocol)));
              },
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFFDB1010BF),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
        Text('aus Gebäuden gerettet',
            style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 6),
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) => setState(() => _currentValue = value),
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

class _Brand_TiereGerettet extends StatefulWidget {
  final Protocol? protocol;

  _Brand_TiereGerettet({Key? key, @required this.protocol}) : super(key: key);

  @override
  _Brand_TiereGerettetState createState() => _Brand_TiereGerettetState();
}

class _Brand_TiereGerettetState extends State<_Brand_TiereGerettet> {
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
              onChanged: (value) => setState(() => tiereGerettet = value),
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
              onChanged: (value) => setState(() => tiereTot = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            Divider(height: 50, thickness: 2, color: buttonColor),
            ElevatedButton(
              child: Text("Next"),
              onPressed: () {
                widget.protocol!.tiereGerettet = tiereGerettet;
                widget.protocol!.tiereTot = tiereTot;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            _Brand_Statistik(protocol: widget.protocol)));
                //Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
        Text('aus Gebäuden gerettet',
            style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 6),
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) => setState(() => _currentValue = value),
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

class _Brand_Statistik extends StatefulWidget {
  final Protocol? protocol;

  _Brand_Statistik({Key? key, @required this.protocol}) : super(key: key);

  @override
  _Brand_StatistikState createState() => _Brand_StatistikState();
}

class _Brand_StatistikState extends State<_Brand_Statistik> {
  TextEditingController _entdeckungController = new TextEditingController();
  TextEditingController _ausmassController = new TextEditingController();
  TextEditingController _klasseController = new TextEditingController();
  TextEditingController _brandController = new TextEditingController();
  TextEditingController _objektartController = new TextEditingController();
  TextEditingController _bauartController = new TextEditingController();
  TextEditingController _lageController = new TextEditingController();
  TextEditingController _verlaufController = new TextEditingController();
  List<String> entdeckungItems = ['Test 1', 'Test 2'];
  String? selectedEntdeckung  = 'Test 1';
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
              Text("Brand-Entdeckung"),
              DropdownButton<String>(
                value: selectedEntdeckung,
                items: entdeckungItems
                      .map((item)=> DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 24)),
                ))
                .toList(),
                onChanged: (item) => setState(()=> selectedEntdeckung = item),
              ),
              /*TextField(
                  controller: _entdeckungController,
                  decoration: InputDecoration(
                    labelText: "Brand - Entdeckung",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),*/
              const SizedBox(height: 10),
              TextField(
                  controller: _ausmassController,
                  decoration: InputDecoration(
                    labelText: "Brand - Ausmaß",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),
              const SizedBox(height: 10),
              TextField(
                  controller: _klasseController,
                  decoration: InputDecoration(
                    labelText: "Brand - Klasse",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),
              const SizedBox(height: 10),
              TextField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: "Brand",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),
              const SizedBox(height: 10),
              TextField(
                  controller: _objektartController,
                  decoration: InputDecoration(
                    labelText: "Objektart",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),
              const SizedBox(height: 10),
              TextField(
                  controller: _bauartController,
                  decoration: InputDecoration(
                    labelText: "Brand - Bauart",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),
              const SizedBox(height: 10),
              TextField(
                  controller: _lageController,
                  decoration: InputDecoration(
                    labelText: "Brand - Lage",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),
              const SizedBox(height: 10),
              TextField(
                  controller: _verlaufController,
                  decoration: InputDecoration(
                    labelText: "Brand - Verlauf",
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                  )),
              Divider(height: 50, thickness: 2, color: buttonColor),
              ElevatedButton(
                child: Text("Next"),
                onPressed: () {
                  widget.protocol!.brandEndeckung = selectedEntdeckung;
                  widget.protocol!.brandAusmass = _ausmassController.text;
                  widget.protocol!.brandKlasse = _klasseController.text;
                  widget.protocol!.brand = _brandController.text;
                  widget.protocol!.objektart = _objektartController.text;
                  widget.protocol!.brandBauart = _bauartController.text;
                  widget.protocol!.brandLage = _lageController.text;
                  widget.protocol!.brandVerlauf = _verlaufController.text;

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
                  //Navigator.of(context)
                  // .pushNamedAndRemoveUntil('/protocol', (Route<dynamic> route) => false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return Info();
                  }), (route) {
                    // if( route is (MaterialPageRoute('/')))
                    // {
                    //   // }
                    // print(route);
                    return false;
                  });

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             TechnischView(protocol: widget.protocol)));
                },
                style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(
          color: Colors.greenAccent,
          width: 3,
        ));
  }

  Widget counter(BuildContext context, int _currentValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16),
        Text('aus Gebäuden gerettet',
            style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 6),
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          axis: Axis.horizontal,
          onChanged: (value) => setState(() => _currentValue = value),
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
