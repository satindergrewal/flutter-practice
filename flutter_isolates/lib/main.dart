/// Example code from: https://codingwithjoe.com/dart-fundamentals-isolates/
/// Flutter example code from: https://gist.github.com/jebright/a7086adc305615aa3a655c6d8bd90264
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:isolate';
import 'lifecycle_manager.dart';

import 'dart:ffi';

// import 'package:ffi/ffi.dart';

// -- Normal gRPC server type definitions --
typedef startgrpc_func = void Function();
typedef StartGrpc = void Function();

typedef stopgrpc_func = void Function();
typedef StopGrpc = void Function();

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
          child: MaterialApp(
        title: 'Flutter Isolate Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Flutter Isolates'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;

  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_startGrpc, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone: () {
      print("done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      _counter++;
      String msg = 'notification ' + _counter.toString();
      print('SEND: ' + msg);
      sendPort.send(msg);
    });
  }

  static void _startGrpc(SendPort sendPort) async {
    // -- Normal gRPC server start code --
    final greeter = DynamicLibrary.open('assets/greeter.so');
    final void Function() startGrpc = greeter
        .lookup<NativeFunction<Void Function()>>('StartGrpc')
        .asFunction();
    String msg = "Started gRPC server...";
    sendPort.send(msg);
    startGrpc();
  }

  static void _stopGrpc() async {
    // -- Normal gRPC server stop code --
    final greeter = DynamicLibrary.open('assets/greeter.so');
    final void Function() stopGrpc = greeter
        .lookup<NativeFunction<Void Function()>>('StopGrpc')
        .asFunction();
    // String msg = "Stoped gRPC server...";
    // sendPort.send(msg);
    stopGrpc();
  }

  void _handleMessage(dynamic data) {
    print('RECEIVED: ' + data);
    setState(() {
      notification = data;
    });
  }

  void _stop() {
    if (_isolate != null) {
      setState(() {
        _running = false;
        notification = '';
      });
      _stopGrpc();
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: WillPopScope(
              onWillPop: () async {
                print('Do you want to quit?');
                return false;
              },
              child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                notification,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _running ? _stop : _start,
        tooltip: _running ? 'Timer stop' : 'Timer start',
        child: _running ? new Icon(Icons.stop) : new Icon(Icons.play_arrow),
      ),
    );
  }
}
