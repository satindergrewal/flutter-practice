// source from: https://codingwithjoe.com/dart-fundamentals-isolates/

import 'dart:io';
// import 'dart:async';
import 'dart:isolate';

import 'dart:ffi';

// import 'package:ffi/ffi.dart';
// import 'package:args/args.dart';

typedef add_func = Int64 Function(Int64, Int64);
typedef Add = int Function(int, int);

Isolate isolate;

void start() async {
  ReceivePort receivePort= ReceivePort(); //port for this main isolate to receive messages.
  isolate = await Isolate.spawn(add, receivePort.sendPort);
  receivePort.listen((data) {
    stdout.write('RECEIVE: ' + data + ', ');
  });
}

void add(SendPort sendPort) {
  final awesome = DynamicLibrary.open('./awesome.so');

  final Add add = awesome.lookup<NativeFunction<add_func>>('Add').asFunction();
  stdout.writeln("FROM ADD FUNCTION: awesome.Add(12, 99) = ${add(12, 99)}");
  String msg = "${add(12, 99)}";
  sendPort.send(msg);
}

void stop() {  
  if (isolate != null) {
      stdout.writeln('killing isolate');
      isolate.kill(priority: Isolate.immediate);
      isolate = null;        
  }  
}

void main() async {
  stdout.writeln('spawning isolate...');
  await start();
  stdout.writeln('press enter key to quit...');
  // await stdin.first;
  stop();
  stdout.writeln('goodbye!');
  exit(0);
}