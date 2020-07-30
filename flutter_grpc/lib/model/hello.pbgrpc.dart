///
//  Generated code. Do not modify.
//  source: hello.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'google/protobuf/empty.pb.dart' as $0;
import 'hello.pb.dart' as $1;
export 'hello.pb.dart';

class HelloServiceClient extends $grpc.Client {
  static final _$sayHello = $grpc.ClientMethod<$0.Empty, $1.ResponseHello>(
      '/model.HelloService/SayHello',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ResponseHello.fromBuffer(value));

  HelloServiceClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$1.ResponseHello> sayHello($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$sayHello, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class HelloServiceBase extends $grpc.Service {
  $core.String get $name => 'model.HelloService';

  HelloServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ResponseHello>(
        'SayHello',
        sayHello_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ResponseHello value) => value.writeToBuffer()));
  }

  $async.Future<$1.ResponseHello> sayHello_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return sayHello(call, await request);
  }

  $async.Future<$1.ResponseHello> sayHello(
      $grpc.ServiceCall call, $0.Empty request);
}
