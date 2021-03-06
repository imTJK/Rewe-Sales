import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';


void main() => runApp(MaterialApp(home: ReweSales()));



Future<List<Product>> fetchProduct() async {
  final response = await http.get("http://imtjk.pythonanywhere.com/products/0/100");
  List<Product> products = [];
  if (response.statusCode == 200) {
    var parsed_json = jsonDecode(response.body)['products'];
    for(int i = 0; i < parsed_json.length; i++){
      products.add(Product.fromJson(parsed_json[i]));
    }
    return products;
  }
  else {
    throw Exception("Failed to load");
  }
}

class Product {
   final int id;
   final String name;
   final double price;
   final String category;
   final bool on_sale;
   final String img_src;

   Product({this.id, this.name, this.price, this.category, this.on_sale, this.img_src});
   factory Product.fromJson(Map<String, dynamic> json) {
     return Product(
       id: json['id'],
       name: json['name'],
       price: json['price'],
       category: json['category'],
       on_sale: json['on_sale'],
       img_src: json['img_src']
     );
   }

}

class ReweSales extends StatefulWidget {

  @override
  _ReweSalesState createState() => _ReweSalesState();
}

class _ReweSalesState extends State<ReweSales> {
  TextEditingController _passwortController = TextEditingController();
  String _passwortError;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(201, 30, 30, 90),
        appBar: AppBar(
        title: Center(child: Text('Anmelden')),
        backgroundColor: Color.fromRGBO(201, 30, 30,100),
      ),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
              <Widget>[
                Container(child: Center(
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Name",
                          ))),
                    width: 300, height: 45, color: Colors.white70),
                Container(child: Center(
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "E-Mail",
                        ))),
                    width: 300, height: 45, color: Colors.white70),
                Container(child: Center(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _passwortController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            errorText: _passwortError,
                            hintText: "Passwort(min. 8 Zeichen)",
                        )))), width: 300, height: 45, color: Colors.white70),

           BottomAppBar(child: TextButton(onPressed: () {
             print(_passwortController);
             setState(() {
               if(_passwortController.text.length < 8)
                 _passwortError = "Muss mindestens 8 Zeichen enthalten";
               else{
                 _passwortError = null;
                 Navigator.of(context).push(
                     MaterialPageRoute(
                         builder: (context) => Products()
                     )
                 );}

             });


           },
            child: Text('Anmelden'),
            ))
              ]
          ))

    );

  }
}


  class Products extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(201, 30, 30, 90),
        appBar: AppBar(
          title: Center(child: Text('Produkte')),
          backgroundColor: Color.fromRGBO(201, 30, 30,100),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
        ),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: fetchProduct(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.network(snapshot.data[4].img_src);
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          )
        )
      );

  }


  }
  class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {})
    ];

  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){}
    );


  }

  @override
  Widget buildResults(BuildContext context) {

  }

  @override
  Widget buildSuggestions(BuildContext context) {

  }
  
  }