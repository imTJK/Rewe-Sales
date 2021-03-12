import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.name,
    this.email,
    this.passwort,
    this.id,
    this.createdAt,
  });

  String name;
  String email;
  String passwort;
  String id;
  DateTime createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        passwort: json["passwort"],
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "passwort": passwort,
        "id": id,
        "createdAt": createdAt.toIso8601String(),
      };
}

void createUser(
    String name, String email, String password, BuildContext context) async {
  final String apiUrl = "http://imtjk.pythonanywhere.com/register";

  final response = await http.post(apiUrl,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{
        "name": name,
        "email": email,
        "password": sha256.convert(utf8.encode(password)).toString(),
        "plz": ""
      }));
  var parsedJson = jsonDecode(response.body);
  if (response.statusCode == 200 && parsedJson['Error'] == null) {
    //User created succesfully, redirect to login Page
  } else if (parsedJson['Error'] != null) {
    //auswerten der Error Message
    //

  }
}
