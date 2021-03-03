import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ReweSales()));

class ReweSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Anmelden')),
        backgroundColor: Color.fromRGBO(35,152,185,100),
      ),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
              <Widget>[
                Container(child: Center(child: Text('Name')), width: 300, height: 100, color: Colors.white),
                Container(child: Center(child: Text('E-Mail')), width: 300, height: 100, color: Colors.white),
                Container(child: Center(child: Text('Passwort')), width: 300, height: 100, color: Colors.white),
              ]
          ))
    );
  }
}
