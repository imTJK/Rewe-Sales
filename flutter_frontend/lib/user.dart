import 'dart:convert';
import 'package:crypto/crypto.dart';
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

Future<User> createUser(
    String name, String email, String password, DateTime createdAt) async {
  final String apiUrl = "http://imtjk.pythonanywhere.com/register";

  final response = await http.post(apiUrl,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{
        "name": name,
        "email": email,
        "password": sha256.convert(utf8.encode(password)).toString(),
        "created_at": createdAt.toString()
      }));
  var parsedJson = jsonDecode(response.body);
  if (response.statusCode == 200 || parsedJson['Error'] != null) {
  } else {
    return null;
  }
}
