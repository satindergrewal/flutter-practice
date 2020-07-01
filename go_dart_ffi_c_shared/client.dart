import 'dart:ffi';
import 'dart:io';

// import 'package:ffi/ffi.dart';
import 'package:args/args.dart';

typedef add_func = Int64 Function(Int64, Int64);
typedef Add = int Function(int, int);

// -- Normal gRPC server type definitions --
typedef startgrpc_func = void Function();
typedef StartGrpc = void Function();

// -- Daemonised gRPC server type definitions --
// CString handeling example is available here:
//   C Function: https://github.com/dart-lang/samples/blob/master/ffi/structs/structs_library/structs.c#L43
//   Dart C definition: https://github.com/dart-lang/samples/blob/master/ffi/structs/structs.dart#L41
//   Dart Function execution: https://github.com/dart-lang/samples/blob/master/ffi/structs/structs.dart#L69

// typedef startgrpc_func = Pointer<Utf8> Function(Pointer<Utf8> str, Int32 length);
// typedef StartGrpc = Pointer<Utf8> Function(Pointer<Utf8> str, int length);

void main(List<String> args) {

  var parser = ArgParser();
  var results = parser.parse(args);
  print(results.rest);

  final awesome = DynamicLibrary.open('./awesome.so');

  final Add add = awesome.lookup<NativeFunction<add_func>>('Add').asFunction();
  stdout.writeln("awesome.Add(12, 99) = ${add(12, 99)}");

  // -- Normal gRPC server start code --
  final greeter = DynamicLibrary.open('./greeter.so');
  final void Function() startGrpc = greeter.lookup<NativeFunction<Void Function()>>('StartGrpc').asFunction();
  startGrpc();


  // -- Daemoned gRPC server start code --
  // final greeter = DynamicLibrary.open('./greeter_daemon.so');
  // // final StartGrpc startGrpc = greeter.lookup<NativeFunction<void>>('StartGrpc').asFunction();

  // final startGrpcPointer = greeter.lookup<NativeFunction<startgrpc_func>>("StartGrpc");
  // final startGrpc = startGrpcPointer.asFunction<StartGrpc>();
  // startGrpc(Utf8.toUtf8('start'), 6);
  // // final void Function() startGrpc = greeter.lookup<NativeFunction<Void Function()>>("StartGrpc").asFunction();
  // // startGrpc();

}

// Compile this file as a native using dart2native
// dart2native client.dart -o dartclient 