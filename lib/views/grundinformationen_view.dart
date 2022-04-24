import 'package:flutter/material.dart';
import 'package:saferfire/models/Protocol.dart';
import 'package:saferfire/views/stammdaten_view.dart';
import 'package:socket_io_client/socket_io_client.dart';


class GrundinformationenView extends StatefulWidget{
  final Protocol? protocol;
  GrundinformationenView({Key? key, @required this.protocol}) : super(key: key);

  @override
  _GrundinformationenViewState createState() => _GrundinformationenViewState();
}

class _GrundinformationenViewState extends State<GrundinformationenView> {
  @override
  Widget build(BuildContext context) {
    DateTime _leitstellenJahr = DateTime.now();
    String _leitstellenjahrString = "2022";

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _leitstellenJahr,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _leitstellenJahr) {
        setState(() {
          _leitstellenJahr = picked;
        });
      }
    }

    // Call this in the select year button.
    void _pickYear(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          final Size size = MediaQuery.of(context).size;
          return AlertDialog(
            title: Text('Select a Year'),
            // Changing default contentPadding to make the content looks better

            contentPadding: const EdgeInsets.all(2),
            content: SizedBox(
              // Giving some size to the dialog so the gridview know its bounds

              height: size.height / 3,
              width: size.width,
              //  Creating a grid view with 3 elements per line.
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  // Generating a list of 123 years starting from 2022
                  // Change it depending on your needs.
                  ...List.generate(
                    123,
                        (index) => InkWell(
                      onTap: () {

                        // The action you want to happen when you select the year below,
                        _leitstellenjahrString = (2022 - index).toString();
                        // Quitting the dialog through navigator.
                        Navigator.pop(context);
                      },
                      // This part is up to you, it's only ui elements
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Chip(
                          label: Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              // Showing the year text, it starts from 2022 and ends in 1900 (you can modify this as you like)
                              (2022 - index).toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Protokoll erstellen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Grundinformationen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 30),
            Text("Einsatznummer: ${widget.protocol!.einstznummer}"),
            Text("Leitstellenjahr"),
            SizedBox(height: 10.0,),
            ElevatedButton(
              onPressed: () => _pickYear(context),
              child: Text('${_leitstellenjahrString}'),
            ),
            const SizedBox(height: 15),
            Text("Kategorie: ${widget.protocol!.kategorie!.split(' ')[0]}"),
            Divider(
                height: 50,
                thickness: 2,
                color: Colors.grey
            ),
            ElevatedButton(
              child: Text("Next"),
              onPressed: (){
                widget.protocol!.leitstellenJahr = _leitstellenJahr;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StammdatenView(protocol: widget.protocol))
                );
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
}