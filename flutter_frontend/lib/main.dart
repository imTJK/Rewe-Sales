import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MaterialApp(home: ReweSales()));

Future<List<Product>> searchProduct(String term) async {
  final response =
      await http.get("http://imtjk.pythonanywhere.com/products?name=${term}");
  List<Product> products = [];
  if (response.statusCode == 200) {
    var parsed_json = jsonDecode(response.body)['products'];
    for (int i = 0; i < parsed_json.length; i++) {
      products.add(Product.fromJson(parsed_json[i]));
    }
    return products;
  } else {
    throw Exception("Failed to load");
  }
}

Future<List<Product>> fetchProduct() async {
  final response =
      await http.get("http://imtjk.pythonanywhere.com/products?name=Wurst");
  print(response);
  List<Product> products = [];
  if (response.statusCode == 200) {
    var parsed_json = jsonDecode(response.body)['products'];
    for (int i = 0; i < parsed_json.length; i++) {
      products.add(Product.fromJson(parsed_json[i]));
    }
    return products;
  } else {
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

  Product(
      {this.id,
      this.name,
      this.price,
      this.category,
      this.on_sale,
      this.img_src});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        category: json['category'],
        on_sale: json['on_sale'],
        img_src: json['img_src']);
  }
}

class ReweSales extends StatefulWidget {
  @override
  _ReweSalesState createState() => _ReweSalesState();
}

class _ReweSalesState extends State<ReweSales> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwortController = TextEditingController();

  String _nameError;
  String _emailError;
  String _passwordError;
  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();
  var _formKey3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(201, 30, 30, 90),
        appBar: AppBar(
          title: Center(child: Text('Anmelden')),
          backgroundColor: Color.fromRGBO(201, 30, 30, 100),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
                  child: Center(
                      child: Form(
                          key: _formKey,
                          child: TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                errorText: _nameError,
                                hintText: "Name",
                              )))),
                  width: 300,
                  height: 45,
                  color: Colors.white70),
              Container(
                  child: Center(
                      child: Form(
                          key: _formKey2,
                          child: TextFormField(
                              controller: _emailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                errorText: _emailError,
                                hintText: "E-Mail",
                              )))),
                  width: 300,
                  height: 45,
                  color: Colors.white70),
              Container(
                  child: Center(
                      child: Form(
                          key: _formKey3,
                          child: TextFormField(
                              controller: _passwortController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                errorText: _passwordError,
                                hintText: "Passwort",
                              )))),
                  width: 300,
                  height: 45,
                  color: Colors.white70),
              BottomAppBar(
                  child: TextButton(
                onPressed: () {
                  print("name: " +
                      _nameController.text +
                      "\nE-Mail: " +
                      _emailController.text +
                      "\nPasswort: ${sha256.convert(utf8.encode(_passwortController.text)).bytes}");
                  setState(() {
                    if (_nameController.text.length < 1)
                      _nameError = "Geben sie einen Namen ein";
                    else
                      _nameError = null;
                    if (_emailController.text.contains("@") != true)
                      _emailError = "Geben sie eine Email ein";
                    else
                      _emailError = null;
                    if (_passwortController.text.length < 8)
                      _passwordError = "Geben sie mindestens 8 Zeichen ein";
                    else {
                      _passwordError = null;
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Products()));
                    }
                  });
                },
                child: Text('Anmelden'),
              ))
            ])));
  }
}

class Products extends StatelessWidget {
  List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(201, 30, 30, 90),
        appBar: AppBar(
          title: Center(child: Text('Produkte')),
          backgroundColor: Color.fromRGBO(201, 30, 30, 100),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
        ),
        body: FutureBuilder(
          future: fetchProduct(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                            child: ListTile(
                          title: Text(snapshot.data[index].name),
                          leading: Image.network(snapshot.data[index].img_src),
                        ));
                      }));
            }
          },
        ));
  }
}

class DataSearch extends SearchDelegate<String> {
  var listExample = ['Yes', 'Peter', 'Peter (Dad)'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> list = List.generate(10, (index) => "Text $index");
  List recentList = [];
  void getProducts()async{
    this.recentList = await fetchProduct();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return Scaffold(
        body: FutureBuilder(
          future: fetchProduct(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {List itemList = snapshot.data.where(
                    (Product) => Product.name.toLowerCase().contains(query.toLowerCase()));

              return Container(
                  child: ListView.builder(
                      itemCount: itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                            child: ListTile(
                              title: Text(itemList[index].name),
                              leading: Image.network(itemList[index].img_src),
                            ));
                      }));
            }
          },
        ));
  }
}
