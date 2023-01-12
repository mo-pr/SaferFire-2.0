import 'package:flutter/material.dart';

const _cardBackgroundColor = Color(0xFFbb1e10);

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Side Bar'),
      ),
      body: const Text("NavBar"),
      drawer: const MyDrawer(),
      extendBody: true,
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.8,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: _cardBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const <Widget>[
                  ],
                ),
              ),
            ),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(2.0),
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  height: 60.0,
                  //MediaQuery.of(context).size.width * .08,
                  width: 220.0,
                  //MediaQuery.of(context).size.width * .3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          height: constraints.maxHeight,
                          width: constraints.maxHeight,
                          decoration: BoxDecoration(
                            color: _cardBackgroundColor,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: const Icon(
                            Icons.navigation,
                            color: Colors.white,
                          ),
                        );
                      }),
                      const Expanded(
                        child: Text(
                          'Open Maps',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
