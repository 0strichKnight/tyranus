import 'dart:async';

import 'package:flutter/material.dart';

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
              }),
          IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () async {
                await widget.addThing(_controller.text);
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
