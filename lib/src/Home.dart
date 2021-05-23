import 'dart:async';
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
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: things.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text('${things[index].name}')
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
                    )
                  )
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

class ThingsToCount extends StatefulWidget {
  ThingsToCount({required this.addThing});

  final FutureOr<void> Function(String thing) addThing;

  @override
  _ThingsToCountState createState() => _ThingsToCountState();
}

class _ThingsToCountState extends State<ThingsToCount> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_thingsToCountState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
          IconButton(
              icon: Icon(Icons.cancel_rounded),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () async {
                await widget.addThing(_controller.text);
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }
}

class Thing {
  Thing({required this.name, required this.count});

  final String name;
  final int count;
}
