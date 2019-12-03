// 1) Create a new Flutter App (in this project) and output an AppBar and some text
// below it
// 2) Add a button which changes the text (to any other text of your choice)
// 3) Split the app into three widgets: App, TextControl & Text

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _btnText = ['Press Me', 'Updated Button Text!'];
  var _btnIndex = 0;

  void textControl() {
    setState(() {
      if (_btnIndex < _btnText.length) {
        _btnIndex += 1;
      }
      print(_btnText.length);
      print(_btnIndex);
      print('Updated Button Text!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Assignment 1'),
        ),
        body: Container(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text(_btnText[_btnIndex]),
            onPressed: textControl,
          ),
        ),
      ),
    );
  }
}
