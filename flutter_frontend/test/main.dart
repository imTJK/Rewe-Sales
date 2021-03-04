import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
                    width: 300, height: 45, color: Colors.white70),
                Container(child: Center(
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "E-Mail",
                        ))),
                    width: 300, height: 45, color: Colors.white70),
                Container(child: Center(
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "Passwort",
                        ))), width: 300, height: 45, color: Colors.white70),

           BottomAppBar(child: TextButton(onPressed: () {
             Navigator.of(context).push(
               MaterialPageRoute(
                 builder: (context) => ReweSales2()
               )
             );
           },
            child: Text('Trau dich'),
            ))
              ]
          ))

    );
  }
}


  class ReweSales2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Center(child: Text('You fell for it fool')))
    );
  }

  }