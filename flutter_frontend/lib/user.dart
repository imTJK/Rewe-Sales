import 'dart:convert';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/authentication.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'homepage.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.name,
    this.email,
    this.password,
    this.id,
    this.createdAt,
  });

  String name;
  String email;
  String password;
  String id;
  String createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        id: json["id"].toString(),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "id": id,
        "createdAt": createdAt,
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
        "password": DBCrypt().hashpw(password, new DBCrypt().gensalt()),
        "plz": ""
      }));
  var parsedJson = jsonDecode(response.body);
  if (response.statusCode == 200 && parsedJson['Error'] == null) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  } else if (parsedJson['Error'] != null) {
    //auswerten der Error Message
    //
  }
}

void loginUser(String name_email, String password, BuildContext context) async {
  final String apiUrl = "http://imtjk.pythonanywhere.com/login";

  Future<http.Response> checkUser(String json) async {
    return await http.post(apiUrl,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: json);
  }

  Response response =
      await checkUser(jsonEncode(<String, String>{"name_email": name_email}));

  if (response.statusCode == 200) {
    var parsedJson = jsonDecode(response.body);
    bool loginSuccess = false;

    if (DBCrypt().checkpw(password, parsedJson['password_hash'])) {
      loginSuccess = true;
    }
    response = await checkUser(jsonEncode(<String, String>{
      "name_email": name_email,
      "login_success": loginSuccess.toString()
    }));

    if (response.statusCode == 200) {
      parsedJson = jsonDecode(response.body);
      User user = User.fromJson(parsedJson);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Homepage(user: user)));
    }
  }
}
