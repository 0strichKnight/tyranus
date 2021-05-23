import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Login extends StatelessWidget {
  Login({required this.signIn});

  final void Function(void Function(Exception e) error) signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tyranus"),
      ),
      body: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(20.0),
            child: Column(
            children: <Widget>[
              Image(image: AssetImage('dooku.jpg')),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 10),
                child: ElevatedButton(
                  onPressed: () => signIn((e) => log("error")),
                  child: Text("Sign in"),
                ),
              )
            ],
          )
          )
      )
    );
  }
}