import 'dart:ffi';
import 'dart:io';


typedef add_func = Int64 Function(Int64, Int64);
typedef Add = int Function(int, int);

void main(List<String> args) {

  final awesome = DynamicLibrary.open('./awesome.so');

  final Add add = awesome.lookup<NativeFunction<add_func>>('Add').asFunction();
  stdout.writeln("awesome.Add(12, 99) = ${add(12, 99)}");
}