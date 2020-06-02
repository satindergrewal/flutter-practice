import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MagicBall());

class MagicBall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ask Me Anything',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MagicBallPage(title: 'Ask Me Anything'),
    );
  }
}

class MagicBallPage extends StatefulWidget {
  MagicBallPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MagicBalltate createState() => _MagicBalltate();
}

class _MagicBalltate extends State<MagicBallPage> {
  int askRandom = 2;

  void calcBallRandom() {
    setState(() {
      askRandom = Random().nextInt(5) + 1;
      print(askRandom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
                  calcBallRandom();
                },
                child: Image.asset('images/ball$askRandom.png'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue.shade900,
    );
  }
}
