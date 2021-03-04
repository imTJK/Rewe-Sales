import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

void main() => runApp(MaterialApp(home: ReweSales()));

Future<Product> fetchPost () async {
  final response = await http.get("http://jsonplaceholder.typicode.com/posts/1");

  if (response.statusCode == 200) {
    return Product.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to load");
  }
}

class Product {
   final int id;
   final String name;
   final double price;
   final String producer;
   final bool on_sale;

   Product({this.id, this.name, this.price, this.producer, this.on_sale});
   factory Product.fromJson(Map<String, dynamic> json) {
     return Product(
       id: json['id'],
       name: json['name'],
       price: json['price'],
       producer: json['producer'],
       on_sale: json['on_sale']
     );
   }

}

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
                 builder: (context) => Products()
               )
             );
           },
            child: Text('Anmelden'),
            ))
              ]
          ))

    );

  }
}


  class Products extends StatelessWidget {
    final Future<Product> product = fetchPost();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Center(child: Text('Suchen'))),
      body: Center(
        child: FutureBuilder<Product>(
          future: product,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.name);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        )
      )
    );

  }


  }