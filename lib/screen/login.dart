import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../entities/user.dart';
import 'dashboard.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  User user = User("", "");
  String url = "http://10.0.2.2:8080/login";
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  Future save(user) async {
    var res = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': user.email, 'password': user.password}),
    );

    if (res.body != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              height: 400.0,
              width: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login to Your Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailCtrl,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Email",
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        // Your validation logic
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordCtrl,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      obscureText: true,
                      validator: (value) {
                        // Your validation logic
                      },
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 243, 222, 33),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 243, 229, 33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          save(User(emailCtrl.text, passwordCtrl.text));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
