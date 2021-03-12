import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/search.dart';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final String onSale; // change to bool with db update
  final String imgSrc;

  Product(
      {this.id,
      this.name,
      this.price,
      this.category,
      this.onSale,
      this.imgSrc});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        category: json['category'],
        onSale: json['on_sale_in'],
        imgSrc: json['img_src']);
  }
}

Future<List<Product>> fetchProduct(
    Map<String, String> args, int amount, int page) async {
  /// url-options
  /// page = page of results your on
  /// amount = how many results to return
  /// category = category of products, equals
  /// name = name of products, contains
  /// on_sale = boolean, checks if products is on sale
  /// plz = zipcode of the rewe the user is looking for (watchlist)
  String url = "http://imTJK.pythonanywhere.com/products/$page/$amount?";
  if (args.entries.length > 0) {
    for (MapEntry<String, String> arg in args.entries) {
      url = url + arg.key.toString() + "=" + arg.value.toString() + "&";
    }
  } else {
    throw Exception("Failed request");
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
                  child: Image.network(product.imgSrc,
                      width: 300, height: 300, fit: BoxFit.fill))),
          Container(
              child: Text(product.price.toString() + "Äpfel? Birnen?",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center)),
          product.onSale != null
              ? Container(
                  child: Text(
                  "On Sale in " + product.onSale.toString(),
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
