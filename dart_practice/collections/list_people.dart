import 'dart:io';
import 'dart:async';

main(List<String> args) {
  List people = ['John', 'Bob', 'Alice', 'Lisa'];

  stdout.write(
      'Type number between 1 and ${people.length - 1} to display person\'s name:\n');

  var index = stdin.readLineSync();

  stdout.write(
      'person on index ${index} is = ${people[int.parse(index) - 1]}\n\n');
  print(people.elementAt(int.parse(index) - 1));
  print('Values in people list are = ${people}');
}
