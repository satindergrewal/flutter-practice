import 'package:flutter_grpc/common/grpc_commons.dart';
import 'package:flutter_grpc/model/google/protobuf/empty.pb.dart';
import 'package:flutter_grpc/model/hello.pb.dart';
import 'package:flutter_grpc/model/hello.pbgrpc.dart';

class HelloService {
  static Future<ResponseHello> SayHello() async{
    var client = HelloServiceClient(GrpcClientSingleton().client);
    return await client.sayHello(Empty());
  }
}