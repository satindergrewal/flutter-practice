import 'package:flutter_grpc/common/grpc_commons.dart';
import 'package:flutter_grpc/model/helloworld.pb.dart';
import 'package:flutter_grpc/model/helloworld.pbgrpc.dart';

class HelloWorldService {
  static Future<HelloReply> SayHello(String name) async{
    var client = GreeterClient(GrpcClientSingleton().client);
    return await client.sayHello(HelloRequest()..name = name);
  }
}