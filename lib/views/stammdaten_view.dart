import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';
import 'package:saferfire/views/brand_view.dart';
import 'package:saferfire/views/technisch_view.dart';

import '../constants.dart';


const _cardBackgroundColor = Color(0xFFbb1e10);
class StammdatenView extends StatefulWidget{
  final Protocol? protocol;
  const StammdatenView({Key? key, @required this.protocol}) : super(key: key);

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
        backgroundColor: mainColor,
        title: const Text('Protokoll erstellen'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          child: Column(
            children: <Widget>[
              const Text(
                'Stammdaten',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 30),
              const Text(
                'Uhrzeit Ausfahrt:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              MaterialButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitAusfahrt);
                },
                minWidth: 150,
                color: _cardBackgroundColor,
                textColor: Colors.black,
                child: Text(
                  "${_uhrzeitAusfahrt.hour}:${_uhrzeitAusfahrt.minute}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                padding: const EdgeInsets.all(6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //side: BorderSide(color: Colors.red)
                ),
              ),
              const Text("Tap to change",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300)
              ),
              const SizedBox(height: 15),
              const Text(
                'Uhrzeit Ankunft:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitAnkunft);
                },
                minWidth: 150,
                color: _cardBackgroundColor,
                textColor: Colors.black,
                child: Text(
                  "${_uhrzeitAnkunft.hour}:${_uhrzeitAnkunft.minute}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                padding: const EdgeInsets.all(6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //side: BorderSide(color: Colors.red)
                ),
              ),
              const Text("Tap to change",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300)
              ),
              const SizedBox(height: 15),
              const Text(
                'Uhrzeit wieder Einsatzbereit:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitEinsatzbereit);
                },
                minWidth: 150,
                color: _cardBackgroundColor,
                textColor: Colors.black,
                child: Text(
                  "${_uhrzeitEinsatzbereit.hour}:${_uhrzeitEinsatzbereit.minute}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                padding: const EdgeInsets.all(6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //side: BorderSide(color: Colors.red)
                ),
              ),
              const Text("Tap to change",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300)
              ),
              const SizedBox(height: 15),
              const Text(
                'Uhrzeit Einsatz-Ende:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                onPressed: () {
                  _selectTime(context, _uhrzeitEnde);
                },
                minWidth: 150,
                color: _cardBackgroundColor,
                textColor: Colors.black,
                child: Text(
                  "${_uhrzeitEnde.hour}:${_uhrzeitEnde.minute}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                padding: const EdgeInsets.all(6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //side: BorderSide(color: Colors.red)
                ),
              ),
              const Text("Tap to change",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300)
              ),
              Divider(
                  height: 50,
                  thickness: 2,
                  color: mainColor
              ),
              ElevatedButton(
                  child: const Text("Next"),
                  onPressed: (){
                    widget.protocol!.uhrzeitAnkunft = _uhrzeitAnkunft;
                    widget.protocol!.uhrzeitEnde = _uhrzeitEnde;
                    widget.protocol!.uhrzeitWiederbereit = _uhrzeitEinsatzbereit;
                    if(widget.protocol!.kategorie!.split(' ')[0] == "TECHNISCH"){
                      widget.protocol!.isTechnisch = true;
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TechnischView(protocol: widget.protocol))
                      );
                    }
                    if(widget.protocol!.kategorie!.split(' ')[0] == "BRAND"){
                      widget.protocol!.isTechnisch = false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BrandView(protocol: widget.protocol))
                      );
                    }
                  },
                style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    textStyle: const TextStyle(
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