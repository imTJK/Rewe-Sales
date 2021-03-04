import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ReweSales()));

class ReweSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 152, 185, 90),
        appBar: AppBar(
        title: Center(child: Text('Anmelden')),
        backgroundColor: Color.fromRGBO(35,152,185,100),
      ),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
              <Widget>[
                Container(child: Center
                  (child: TextField(
                    decoration: InputDecoration(
                        hintText: "Name",
                          ))),
                    width: 300, height: 50, color: Colors.white70),
                Container(child: Center(
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "E-Mail",
                        ))),
                    width: 300, height: 50, color: Colors.white70),
                Container(child: Center(
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "Passwort",
                        ))), width: 300, height: 50, color: Colors.white70),
              ]
          ))

    );
  }
}
