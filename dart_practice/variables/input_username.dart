import 'dart:io';
import 'dart:async';

main(List<String> args) {
  stdout.write('What is your first name?\n');
  String firstname = stdin.readLineSync();

  stdout.write('What is your last name?\n');
  String lastname = stdin.readLineSync();

  stdout.write('Hello ${firstname} ${lastname}\n\n');
}
