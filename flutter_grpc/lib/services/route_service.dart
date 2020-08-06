import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;
import 'package:flutter_grpc/common/grpc_commons.dart';
import 'package:flutter_grpc/model/google/protobuf/empty.pb.dart';
import 'package:flutter_grpc/model/route_guide.pb.dart';
import 'package:flutter_grpc/model/route_guide.pbgrpc.dart';

const coordFactor = 1e7;

final List<Feature> featuresDb = _readDatabase();

List<Feature> _readDatabase() {
  final dbData = File('lib/assets/route_guide_db.json').readAsStringSync();
  final List db = jsonDecode(dbData);
  return db.map((entry) {
    final location = Point()
      ..latitude = entry['location']['latitude']
      ..longitude = entry['location']['longitude'];
    return Feature()
      ..name = entry['name']
      ..location = location;
  }).toList();
}

class RouteGuideService {
  RouteGuideClient stub;
  
  static Future<Feature> GetFeature() async{
    var client = RouteGuideClient(GrpcClientSingleton().client);
    final point1 = Point()
      ..latitude = 409146138
      ..longitude = -746188906;
      printFeature(await client.getFeature(point1));
    return await client.getFeature(point1);
  }

  
  
  static void printFeature(Feature feature) {
    final latitude = feature.location.latitude;
    final longitude = feature.location.longitude;
    final name = feature.name.isEmpty
        ? 'no feature'
        : 'feature called "${feature.name}"';
    print(
        'Found $name at ${latitude / coordFactor}, ${longitude / coordFactor}');
  }

  /// Run the getFeature demo. Calls getFeature with a point known to have a
  /// feature and a point known not to have a feature.
  Future<void> runGetFeature() async {
    final point1 = Point()
      ..latitude = 409146138
      ..longitude = -746188906;
    final point2 = Point()
      ..latitude = 0
      ..longitude = 0;

    printFeature(await stub.getFeature(point1));
    printFeature(await stub.getFeature(point2));
  }
}