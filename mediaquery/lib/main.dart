import 'package:flutter/material.dart';
import 'package:mediaquery/sizes_helpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sizes... sizes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sizes... sizes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.red,
              width: displayWidth(context) * 0.25,
              child: Text(
                'Box width 25% of screen width and text size 3% of screen width',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: displayWidth(context) * 0.03),
              ),
            ),
            Container(
              color: Colors.green,
              width: displayWidth(context) * 0.5,
              child: Text(
                'Box width 50% of screen width and text size 6% of screen width',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: displayWidth(context) * 0.06),
              ),
            ),
            Container(
              color: Colors.blue,
              width: displayWidth(context),
              child: Text(
                'Box width equal to screen width and text size 10% of screen width',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: displayWidth(context) * 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
