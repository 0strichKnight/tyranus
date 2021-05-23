import 'package:flutter/material.dart';

import 'ApplicationLoginState.dart';
import 'Login.dart';

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
        return Login(
          signIn: this.signIn,
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
