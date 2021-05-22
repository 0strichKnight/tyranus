import 'dart:developer';
import 'package:flutter/material.dart';

import 'ApplicationLoginState.dart';

class Home extends StatelessWidget {
  const Home({
    required this.loginState,
    required this.signIn,
    required this.signOut,
  });

  final ApplicationLoginState loginState;
  final void Function(void Function(Exception e) error) signIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Scaffold(
          appBar: AppBar(
            title: Text('Dooku'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    signIn((e) => log("error"));
                  },
                  child: Text("Log in")),
            ],
          ),
        );
      case ApplicationLoginState.loggedIn:
        return Scaffold(
          appBar: AppBar(
            title: Text('Tyranus'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => signOut(),
                  child: Text("Log out")),
            ]
          ),
        );
      default:
        return Center(
          child: Text("I feel a disturbance in the force..."),
        );
    }
  }
}
