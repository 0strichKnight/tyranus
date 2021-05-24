import 'dart:async';
import 'dart:developer';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tyranus/src/Home.dart';

import 'src/Models.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tyranus',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Consumer<ApplicationState>(
        builder: (context, appData, _) => Home(
          loginState: appData.loginState,
          signIn: appData.signInGoogle,
          signOut: appData.signOut,
          addThing: appData.addThing,
          things: appData.things,
          increment: appData.incrementThing,
        ),
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;

  ApplicationLoginState get loginState => _loginState;

  StreamSubscription<QuerySnapshot>? _thingsSubscription;
  List<Thing> _things = [];

  List<Thing> get things => _things;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        _loginState = ApplicationLoginState.loggedOut;
        _things = [];
        _thingsSubscription?.cancel();
      } else {
        _loginState = ApplicationLoginState.loggedIn;
        _thingsSubscription = FirebaseFirestore.instance
            .collection('things')
            .where("user", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('timestamp')
            .snapshots()
            .listen((snapshot) {
          _things = [];
          snapshot.docs.forEach((doc) {
            _things.add(Thing(
              id: doc.id,
              name: doc.data()['name'],
              count: doc.data()['count'],
            ));
          });
          notifyListeners();
        });
      }
      notifyListeners();
    });
  }

  void signInGoogle(void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<DocumentReference> addThing(String thing) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Nooooooo!');
    }

    return FirebaseFirestore.instance.collection('things').add({
      'name': thing,
      'count': 0,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
      'user': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> incrementThing(Thing thing) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception("Nooooo!");
    }

    return FirebaseFirestore.instance.collection('things').doc(thing.id).update({
      "count": thing.count + 1
    });
  }
}
