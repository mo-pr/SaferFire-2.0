import 'package:flutter/material.dart';

class DangerousGoods extends StatefulWidget {
  const DangerousGoods({super.key});

  @override
  DangerousGoodsState createState() => DangerousGoodsState();
}

class DangerousGoodsState extends State<DangerousGoods> {
  TextEditingController teSeach = TextEditingController();
  List<ADRobj> adrs = [];
  List<ADRobj> items = [];

  @override
  void initState() {
    super.initState();
    adrs.clear();
    items.clear();
    getData();
  }

  Future getData() async {

  }

  void _showDetail(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("UN-Nummer: " +
                  adrs.asMap()[index].unnr.padLeft(4, '0') +
                  "\n\n" +
                  adrs.asMap()[index].bez),
              actions: <Widget>[
                TextButton(
                    child: const Text('Abbrechen'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void filterSeach(String query) async {
    List<ADRobj> searchList = adrs;
    List<ADRobj> dummySearch = [];
    if (query == "" || query == " ") {
      setState(() {
        items.clear();
        items = adrs;
      });
    } else {
      for (ADRobj item in searchList) {
        if (item.unnr.toLowerCase().contains(query.toLowerCase())) {
          dummySearch.add(item);
        }
      }
      setState(() {
        items.clear();
        items.addAll(dummySearch);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.black87),
                labelText: 'Search',
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
                                        "assets/2000px-ADR33_UN1203.svg.png")),
                              ),
                              title: Text(
                                items[index].unnr.padLeft(4, '0'),
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

class ADRobj {
  String unnr;
  String gefnr;
  String klasse;
  String bez;

  ADRobj(this.unnr, this.gefnr, this.klasse, this.bez);
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}