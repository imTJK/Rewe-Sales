import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/products.dart';
import 'package:flutter_frontend/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  User _user;

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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String email = _emailController.text;
                        final String passwort = _passwortController.text;

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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Products()));
                        }
                      },
                      child: Text('Anmelden'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                        },
                        child: Text('Noch kein Konto? Hier klicken'))
                  ]))
            ])));
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  User _user;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwortController = TextEditingController();
  TextEditingController _passwortController2 = TextEditingController();

  String _nameError;
  String _emailError;
  String _passwordError;
  String _passwordError2;

  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();
  var _formKey3 = GlobalKey<FormState>();
  var _formKey4 = GlobalKey<FormState>();

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
              Container(
                  child: Center(
                      child: Form(
                          key: _formKey4,
                          child: TextFormField(
                              controller: _passwortController2,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                errorText: _passwordError2,
                                hintText: "Passwort bestätigen",
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

                    //final User user = await createUser(name, email, passwort, DateTime.now());

                    //  setState(() {_user = user;});

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
                    }
                    if (_passwortController2.text != _passwortController.text) {
                      _passwordError2 =
                          "Geben sie bitte das gleiche Passwort ein";
                    } else {
                      _passwordError2 = null;
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Products()));
                    }
                  },
                  child: Text('Registrieren'),
                ),
              )
            ])));
  }
}
