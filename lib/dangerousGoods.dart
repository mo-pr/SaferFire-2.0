import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saferfire/dangerousGood.dart';
import 'constants.dart';

class DangerousGoods extends StatefulWidget {
  const DangerousGoods({super.key});

  @override
  DangerousGoodsState createState() => DangerousGoodsState();
}

class DangerousGoodsState extends State<DangerousGoods> {
  TextEditingController teSeach = TextEditingController();
  List<DangerousGood> adrs = [];
  List<DangerousGood> items = [];

  @override
  void initState() {
    super.initState();
    adrs.clear();
    items.clear();
    getData();
    filterSeach("");
  }

  Future getData() async {
    var res = await http.post(
      Uri.parse('http://$ipAddress/dangerousgoods'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiQWRtaW4iLCJpYXQiOjE2NDY5MDY1NDQsImV4cCI6MTY3ODQ0MjU0NH0.6YuZjOA_t-SGFg3cVZH0IYrBIUOEMbTRXHcBupmih2Q',
      }),
    );
    Iterable l = json.decode(res.body);
    List<DangerousGood> goods = List<DangerousGood>.from(l.map((model)=> DangerousGood.fromJson(model)));
    goods.sort((a,b)=> a.unNr.compareTo(b.unNr));
    adrs = items = goods;
  }

  void _showDetail(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("UN-Nummer: " +
                  items.asMap()[index]!.unNr.toString().padLeft(4, '0') +
                  "\n\n" +
                  items.asMap()[index]!.name),
              actions: <Widget>[
                TextButton(
                    child: const Text('Schließen'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void filterSeach(String query) async {
    List<DangerousGood> results = [];
    if (query.isEmpty) {
      results = adrs;
    } else {
      results = adrs
          .where((good) =>
          good.unNr.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      items = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Gefahrstoffe"),
        centerTitle: true,
        backgroundColor: Colors.red[700],
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black87),
              onChanged: (value) {
                setState(() {
                  filterSeach(value);
                });
              },
              cursorColor: const Color(0xffb32b19),
              controller: teSeach,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Color(0xffb32b19)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Color(0xffb32b19)),
                ),
                hintText: 'Suchen...',
                hintStyle: const TextStyle(color: Colors.black87),
                labelText: 'Suchen',
                labelStyle: const TextStyle(color: Colors.black87),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xffb32b19),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () => _showDetail(index),
                      child: Container(
                          color: Colors.transparent,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: Constants.padding,
                                child: ClipRRect(
                                    child: Image.asset(
                                        "assets/adr.svg")),
                              ),
                              title: Text(
                                items[index].unNr.toString().padLeft(4, '0'),
                                style: const TextStyle(
                                    fontSize: 19.0, color: Colors.black87),
                              ),
                            ),
                          )));
                }),
          ),
        ],
      ),
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}