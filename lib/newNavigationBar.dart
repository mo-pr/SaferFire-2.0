
import 'package:flutter/material.dart';

const _backgroundColor = Color(0xFFE5E5E5);
const _cardBackgroundColor = Color(0xFFbb1e10);

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Side Bar'),
      ),
      body: Text("NavBar"),
      drawer: MyDrawer(),
      extendBody: true,
    );
  }
}

class MyDrawer extends StatelessWidget {
//   final Function onTap;
//
//   MyDrawer({
//     this.onTap
// });

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
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[

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
