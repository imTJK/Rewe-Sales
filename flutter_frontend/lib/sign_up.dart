// To parse this JSON data, do
//
//     final signUp = signUpFromJson(jsonString);

import 'dart:convert';

SignUp signUpFromJson(String str) => SignUp.fromJson(json.decode(str));

String signUpToJson(SignUp data) => json.encode(data.toJson());

class SignUp {
  SignUp({
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

  factory SignUp.fromJson(Map<String, dynamic> json) => SignUp(
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
