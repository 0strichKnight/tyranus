import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    )
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tyranus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tyranus'),
      ),
      body: Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
              loginState: appState.loginState,
              signIn: appState.signInAnonymous,
              signOut: appState.signOut)
        ),
      ),
    );
  }
}

class Authentication extends StatelessWidget {
  const Authentication({
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
        return Center(
          child: ElevatedButton(
            onPressed: () {
              signIn((e) => log("error"));
              },
            child: Text("Log in"),
          ),
        );
      case ApplicationLoginState.loggedIn:
        return Center(
          child: Text("Logged in"),
        );
      default:
        return Center(
          child: Text("I feel a disturbance in the force..."),
        );
    }
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        _loginState = ApplicationLoginState.loggedOut;
      } else {
        _loginState = ApplicationLoginState.loggedIn;
      }
      notifyListeners();
    });
  }

  void signInAnonymous(void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}