import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';
import 'package:saferfire/views/brand_view.dart';
import 'package:saferfire/views/technisch_view.dart';

class StammdatenView extends StatefulWidget{
  final Protocol? protocol;
  StammdatenView({Key? key, @required this.protocol}) : super(key: key);

  @override
  _StammdatenViewState createState() => _StammdatenViewState();
}

class _StammdatenViewState extends State<StammdatenView> {
  TimeOfDay  _uhrzeitAusfahrt = TimeOfDay.now();
  TimeOfDay _uhrzeitAnkunft = TimeOfDay.now();
  TimeOfDay _uhrzeitEinsatzbereit = TimeOfDay.now();
  TimeOfDay _uhrzeitEnde = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context, TimeOfDay  _timer) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _timer,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked != null && picked != _timer) {
      setState(() {
        if(_timer == _uhrzeitAusfahrt){
          _uhrzeitAusfahrt = picked;
        }
        else if(_timer == _uhrzeitAnkunft){
          _uhrzeitAnkunft = picked;
        }
        else if(_timer == _uhrzeitEinsatzbereit){
          _uhrzeitEinsatzbereit = picked;
        }
        else if(_timer == _uhrzeitEnde){
          _uhrzeitEnde = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Protokoll erstellen'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          child: Column(
            children: <Widget>[
              Text(
                'Stammdaten',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 30),
              Text(
                'Uhrzeit Ausfahrt:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${_uhrzeitAusfahrt.hour}:${_uhrzeitAusfahrt.minute}"),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitAusfahrt);
                },
                child: Text("Choose Time"),
              ),
              const SizedBox(height: 15),
              Text(
                'Uhrzeit Ankunft:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${_uhrzeitAnkunft.hour}:${_uhrzeitAnkunft.minute}"),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitAnkunft);
                },
                child: Text("Choose Time"),
              ),
              const SizedBox(height: 15),
              Text(
                'Uhrzeit wieder Einsatzbereit:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${_uhrzeitEinsatzbereit.hour}:${_uhrzeitEinsatzbereit.minute}"),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitEinsatzbereit);
                },
                child: Text("Choose Time"),
              ),
              const SizedBox(height: 15),
              Text(
                'Uhrzeit Einsatz-Ende:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${_uhrzeitEnde.hour}:${_uhrzeitEnde.minute}"),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitEnde);
                },
                child: Text("Choose Time"),
              ),
              Divider(
                  height: 50,
                  thickness: 2,
                  color: Colors.grey
              ),
              ElevatedButton(
                  child: Text("Next"),
                  onPressed: (){
                    if(widget.protocol!.kategorie!.split(' ')[0] == "TECHNISCH"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TechnischView(protocol: widget.protocol))
                      );
                    }
                    if(widget.protocol!.kategorie!.split(' ')[0] == "BRAND"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BrandView(protocol: widget.protocol))
                      );
                    }
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
}