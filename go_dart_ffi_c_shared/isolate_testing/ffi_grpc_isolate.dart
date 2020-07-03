// source from: https://codingwithjoe.com/dart-fundamentals-isolates/

import 'dart:io';
import 'dart:async';
import 'dart:isolate';

import 'dart:ffi';

// import 'package:ffi/ffi.dart';
import 'package:args/args.dart';

// -- Normal gRPC server type definitions --
typedef startgrpc_func = void Function();
typedef StartGrpc = void Function();

Isolate isolate;

void start() async {
  ReceivePort receivePort= ReceivePort(); //port for this main isolate to receive messages.
  isolate = await Isolate.spawn(startGrpc, receivePort.sendPort);
  receivePort.listen((data) {
    stdout.write('RECEIVE: ' + data + ', ');
  });
}

void startGrpc(SendPort sendPort) {
  // -- Normal gRPC server start code --
  final greeter = DynamicLibrary.open('./greeter.so');
  final void Function() startGrpc = greeter.lookup<NativeFunction<Void Function()>>('StartGrpc').asFunction();
  startGrpc();
  String msg = "Started gRPC server...";
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
  await stdin.first;
  stop();
  stdout.writeln('goodbye!');
  exit(0);
}