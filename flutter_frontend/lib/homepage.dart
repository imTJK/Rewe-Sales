import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/products.dart';
import 'package:flutter_frontend/search.dart';
import 'package:flutter_frontend/user.dart';

class HomePage extends StatelessWidget {
  User user = new User(name: "tEst",email: "teSt",passwort: "TesT",id: "0", createdAt: DateTime.now());
  HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(201, 30, 30, 90),
      appBar: AppBar(
        title: Center(child: Text('Mein Account')),
        backgroundColor: Color.fromRGBO(201, 30, 30, 100),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: Center(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Mein Username: ' + user.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
        )),
          Text(
              'Meine E-Mail: ' + user.email,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
            )),
      ],

    )));}}