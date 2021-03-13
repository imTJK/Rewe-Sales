import 'package:flutter/material.dart';
import 'package:flutter_frontend/user.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _nameEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _nameEmailError;
  String _passwordError;

  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();

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
                              controller: _nameEmailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                errorText: _nameEmailError,
                                hintText: "Name oder E-Mail",
                              )))),
                  width: 300,
                  height: 45,
                  color: Colors.white70),
              Container(
                  child: Center(
                      child: Form(
                          key: _formKey2,
                          child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                errorText: _passwordError,
                                hintText: "password",
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
                        final String nameEmail = _nameEmailController.text;
                        final String password = _passwordController.text;

                        setState(() {
                          if (_nameEmailController.text.length < 1) {
                            _nameEmailError = "E-Mail oder Name ist inkorrekt";
                          } else {
                            _nameEmailError = null;
                          }
                        });
                        if (_passwordController.text.length < 8) {
                          _passwordError = "password inkorrekt";
                        } else {
                          _passwordError = null;
                          loginUser(nameEmail, password, context);
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();
  void setErrorMessage(TextEditingController _controller) {}
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
                              controller: _passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                errorText: _passwordError,
                                hintText: "password",
                              )))),
                  width: 300,
                  height: 45,
                  color: Colors.white70),
              Container(
                  child: Center(
                      child: Form(
                          key: _formKey4,
                          child: TextFormField(
                              controller: _passwordController2,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                errorText: _passwordError2,
                                hintText: "password bestätigen",
                              )))),
                  width: 300,
                  height: 45,
                  color: Colors.white70),
              BottomAppBar(
                child: TextButton(
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String email = _emailController.text;
                    final String password = _passwordController.text;

                    createUser(name, email, password, context);

                    //  setState(() {_user = user;});
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
                    if (_passwordController.text.length < 8) {
                      _passwordError = "Geben sie mindestens 8 Zeichen ein";
                    } else {
                      _passwordError = null;
                    }
                    if (_passwordController2.text != _passwordController.text) {
                      _passwordError2 =
                          "Geben sie bitte das gleiche password ein";
                    } else {
                      _passwordError2 = null;
                      createUser(_nameController.text, _emailController.text,
                          _passwordController.text, context);
                    }
                  },
                  child: Text('Registrieren'),
                ),
              )
            ])));
  }
}
