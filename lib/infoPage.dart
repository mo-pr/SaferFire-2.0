import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( //use MaterialApp() widget like this
        home: InfoPage() //create new widget class for this 'home' to
      // escape 'No MediaQuery widget found' error
    );
  }
}

class InfoPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD1D1D1),
      body:Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xff4D4F4E),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xff333333).withOpacity(1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 30), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Text(
                  'Einsatzdaten',
                  style: TextStyle(
                      color: Colors.red[500],
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '001',
                  style: TextStyle(
                      color: Colors.red[500]),
                ),
                Text(
                  ' ',
                  style: TextStyle(
                      color: Colors.red[500],
                      fontSize: 25),
                ),
                Text(
                  'Zwettl an der Rodl',
                  style: TextStyle(
                      color: Colors.red[500],
                      fontSize: 25),
                ),
                Text(
                  '4180 / Hochgarten 12',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15),
                ),
                Text(
                  ' ',
                  style: TextStyle(
                      color: Colors.red[500],
                      fontSize: 25),
                ),
                Text(
                  'Hausbrand',
                  style: TextStyle(
                      color: Colors.red[500],
                      fontSize: 25),
                ),
                Text(
                  'schwer',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15),
                ),
                Text(
                  ' ',
                  style: TextStyle(
                      color: Colors.red[500],
                      fontSize: 25),
                ),
                Text(
                  'Feuerwehren',
                  style: TextStyle(
                      color: Colors.red[500],
                      fontSize: 25),
                ),
                Text(
                  'Zwettl / Oberneukirchen / Bad Leonfelden',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Color(0xffF7883C),
        child: InkWell(
          onTap: () => print('open menu'),
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                Text(
                  'InfoPage',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}