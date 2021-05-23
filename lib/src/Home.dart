import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ApplicationLoginState.dart';
import 'Login.dart';

class Home extends StatelessWidget {
  const Home({
    required this.loginState,
    required this.signIn,
    required this.signOut,
    required this.addThing,
    required this.things,
  });

  final ApplicationLoginState loginState;
  final void Function(void Function(Exception e) error) signIn;
  final void Function() signOut;
  final void Function(String thing) addThing;
  final List<Thing> things;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Login(
          signIn: this.signIn,
        );
      case ApplicationLoginState.loggedIn:
        return Scaffold(
          appBar: AppBar(title: Text('Tyranus'), actions: <Widget>[
            IconButton(onPressed: () => signOut(), icon: Icon(Icons.logout)),
          ]),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ThingsToCount(
                  addThing: (text) => this.addThing(text),
                ),
              ),
              SizedBox(height: 8),
              for (var thing in things)
                Text('${thing.name} -> ${thing.count}')
            ],
          ),
        );
      default:
        return Center(
          child: Text("I feel a disturbance in the force..."),
        );
    }
  }
}

class ThingsToCount extends StatefulWidget {
  ThingsToCount({required this.addThing});

  final FutureOr<void> Function(String thing) addThing;

  @override
  _ThingsToCountState createState() => _ThingsToCountState();
}

class _ThingsToCountState extends State<ThingsToCount> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_thingsToCountState');
  final _controller = TextEditingController();
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    if (isAdding) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Add something to count',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Forgot something?';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () async {
                          await widget.addThing(_controller.text);
                          _controller.clear();
                          setState(() {
                            isAdding = false;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 4),
                            Text('ADD')
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ]
      );
    } else {
      return Row(
        children: [
          TextButton(onPressed: () => setState(() => isAdding = true), child: Text("Add")),
        ],
      );
    }
  }
}

class Thing {
  Thing({required this.name, required this.count});

  final String name;
  final int count;
}
