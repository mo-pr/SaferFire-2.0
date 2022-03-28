import 'package:flutter/material.dart';

const _backgroundColor = Color(0xFFE5E5E5);
const _cardBackgroundColor = Color(0xFFbb1e10);

class RespiratoryProtection extends StatefulWidget {
  const RespiratoryProtection({Key? key}) : super(key: key);
  @override
  RespiratoryProtectionPage createState() => RespiratoryProtectionPage();
}

class RespiratoryProtectionPage extends State<RespiratoryProtection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: _backgroundColor,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: _cardBackgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 90.0),
            alignment: Alignment.topCenter,
            child: const Text(
              'SaferFire',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Align(
            alignment: Alignment.center
          ),
        ],
      ),
      extendBody: true,
    );
  }
}
