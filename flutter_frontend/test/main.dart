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
                Container(child: Center(child: TextField(decoration: InputDecoration(hintText: "Name", border: new OutlineInputBorder( borderSide: new BorderSide(color: Colors.transparent))))), width: 300, height: 100, color: Colors.white70),
                Container(child: Center(child: Text('E-Mail')), width: 300, height: 100, color: Colors.white70),
                Container(child: Center(child: Text('Passwort')), width: 300, height: 100, color: Colors.white70),
              ]
          ))
    );
  }
}
