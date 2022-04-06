import 'package:flutter/material.dart';



class Protocol extends StatefulWidget {
  @override
  ProtocolPage createState() => ProtocolPage();
}

class ProtocolPage extends State<Protocol> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          new Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text(
                    "Es wurde noch kein Protokoll erstellt",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Grundinformationen())
                    );
                  },
                  child: Icon(Icons.add, size: 50.0),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Kommentare",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey),
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


class Grundinformationen extends StatelessWidget{


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
