import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:args/args.dart';


typedef add_func = Int64 Function(Int64, Int64);
typedef Add = int Function(int, int);

typedef startgrpc_func = void Function();
typedef StartGrpc = Function();

void main(List<String> args) {

  var parser = ArgParser();
  var results = parser.parse(args);
  print(results.rest);

  final awesome = DynamicLibrary.open('./awesome.so');

  final Add add = awesome.lookup<NativeFunction<add_func>>('Add').asFunction();
  stdout.writeln("awesome.Add(12, 99) = ${add(12, 99)}");

  final greeter = DynamicLibrary.open('./greeter_daemon.so');

  // final StartGrpc startGrpc = greeter.lookup<NativeFunction<void>>('StartGrpc').asFunction();

  final void Function() startGrpc = greeter.lookup<NativeFunction<Void Function()>>("StartGrpc").asFunction();
  startGrpc();
}

// Compile this file as a native using dart2native
// dart2native client.dart -o dartclient 