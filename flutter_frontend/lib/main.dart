import 'dart:ui';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
//import 'package:logging/logging.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'sign_up.dart';

void main() => runApp(MaterialApp(home: Authentication()));

/// Functions ///
Future<List<Product>> fetchProduct(
    Map<String, String> args, int amount, int page) async {
  /// url-options
  /// page = page of results your on
  /// amount = how many results to return
  /// category = category of products, equals
  /// name = name of products, contains
  /// on_sale = boolean, checks if products is on sale
  /// plz = zipcode of the rewe the user is looking for (watchlist)
  String url = "http://imTJK.pythonanywhere.com/products/$amount/$page?";
  for (MapEntry<String, String> arg in args.entries) {
    url = url + arg.key.toString() + "=" + arg.value.toString() + "&";
  }
  final response = await http.get(url);

  List<Product> products = [];
  if (response.statusCode == 200) {
    var parsedJson = jsonDecode(response.body)['products'];
    for (int i = 0; i < parsedJson.length; i++) {
      products.add(Product.fromJson(parsedJson[i]));
    }
    return products;
  } else {
    throw Exception("Failed to load");
  }
}

/// parses User-Data from Authentication to python-Backend, hashes password
Future<SignUp> createUser(
    String name, String email, String passwort, DateTime createdAt) async {
  final String apiUrl = "http://imtjk.pythonanywhere.com/register";

  final response = await http.post(apiUrl,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{
        "name": name,
        "email": email,
        "passwort": sha256.convert(utf8.encode(passwort)).toString(),
        "created_at": createdAt.toString()
      }));
  var parsedJson = jsonDecode(response.body);
  if (response.statusCode == 200 || parsedJson['Error'] != null) {
  } else {
    return null;
  }
}

/// end Functions ///

/// general Classes ///
class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final String on_sale_in;
  final String img_src;

  Product(
      {this.id,
      this.name,
      this.price,
      this.category,
      this.on_sale_in,
      this.img_src});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: double.parse(json['price']),
        category: json['category'],
        on_sale_in: json['on_sale_in'],
        img_src: json['img_src']);
  }
}

/// end general Classes ///

/// Page-Classes ///
/// Home-Page
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
          future: fetchProduct({"": ""}, 25, 0),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print(snapshot);
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

/// specific Product-Page
class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(201, 30, 30, 100),
      body: Center(
          child: new Column(
        children: [
          Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                decoration: ShapeDecoration(
                    color: Color.fromRGBO(201, 30, 30, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                child: Text(product.name,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              )),
          Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(241, 136, 5, 1.0),
                    border: Border.all(width: 4),
                  ),
                  child: Image.network(product.img_src))),
          Container(
              child: Text(product.price.toString(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center)),
          product.on_sale_in != null
              ? Container(
                  child: Text(
                  "On Sale in " + product.on_sale_in.toString(),
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ))
              : Container(child: Text("not on sale"))
        ],
      )),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(201, 30, 30, 100),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.bug_report),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]),
    );
  }
}

/// Sign-up-/Login-Page
class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  SignUp _user;

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
                onPressed: () async {
                  final String name = _nameController.text;
                  final String email = _emailController.text;
                  final String passwort = _passwortController.text;

                  final SignUp user =
                      await createUser(name, email, passwort, DateTime.now());

                  setState(() {
                    _user = user;
                  });

                  print("name: " +
                      _nameController.text +
                      "\nE-Mail: " +
                      _emailController.text +
                      "\nPasswort: ${sha256.convert(utf8.encode(_passwortController.text)).bytes}");
                  setState(() {
                    if (_nameController.text.length < 1) {
                      _nameError = "Geben sie einen Namen ein";
                    } else {
                      _nameError = null;
                    }
                    if (_emailController.text.contains("@") != true) {
                      _emailError = "Geben sie eine Email ein";
                    } else {
                      _emailError = null;
                    }
                  });
                  if (_passwortController.text.length < 8) {
                    _passwordError = "Geben sie mindestens 8 Zeichen ein";
                  } else {
                    _passwordError = null;
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Products()));
                  }
                },
                child: Text('Anmelden'),
              ))
            ])));
  }
}

/// Search-Page/Function
class DataSearch extends SearchDelegate<String> {
  final List<String> list = List.generate(10, (index) => "Text $index");
  List recentList = [];
  List itemList = [];
  Product selectedResult;

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

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: ListTile(
          title: Text("Wack"),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: fetchProduct({"name": query.toLowerCase()}, 10, 0),
      builder: (context, AsyncSnapshot<List<Product>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          itemList = [];
          if (query == "" || snapshot.data.length == 0) {
            itemList = recentList;
          }
          return GestureDetector(
              child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                        child: ListTile(
                            title: Text(itemList[index].name),
                            leading: Image.network(itemList[index].img_src),
                            onTap: () {
                              if (!recentList.contains(itemList[index])) {
                                recentList.add(itemList[index]);
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductPage(product: itemList[index]),
                                ),
                              );
                            }));
                  }),
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              });
        }
      },
    ));
  }
}

/// end Page-Classes ///
