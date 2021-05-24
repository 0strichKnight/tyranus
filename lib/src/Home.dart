import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'Models.dart';
import 'ThingsToCount.dart';

class Home extends StatelessWidget {
  const Home({
    required this.loginState,
    required this.signIn,
    required this.signOut,
    required this.addThing,
    required this.things,
    required this.increment,
  });

  final ApplicationLoginState loginState;
  final void Function(void Function(Exception e) error) signIn;
  final void Function() signOut;
  final void Function(String thing) addThing;
  final void Function(Thing thing) increment;
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
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: things.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('${things[index].name}'),
                  trailing: Wrap(
                    spacing: 10,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                        child: Text('${things[index].count}'),
                      ),
                      TextButton(
                          onPressed: () {
                              increment(things[index]);
                              things[index].count++;
                            },
                            child: Icon(Icons.arrow_circle_up_rounded),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ThingsToCount(
                        addThing: (text) => this.addThing(text),
                      ),
                    ),
                  ),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      default:
        return Center(
          child: Text("I feel a disturbance in the force..."),
        );
    }
  }
}
