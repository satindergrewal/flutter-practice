///
//  Generated code. Do not modify.
//  source: hello.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ResponseHello extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ResponseHello', package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'response')
    ..hasRequiredFields = false
  ;

  ResponseHello._() : super();
  factory ResponseHello() => create();
  factory ResponseHello.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResponseHello.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ResponseHello clone() => ResponseHello()..mergeFromMessage(this);
  ResponseHello copyWith(void Function(ResponseHello) updates) => super.copyWith((message) => updates(message as ResponseHello));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResponseHello create() => ResponseHello._();
  ResponseHello createEmptyInstance() => create();
  static $pb.PbList<ResponseHello> createRepeated() => $pb.PbList<ResponseHello>();
  @$core.pragma('dart2js:noInline')
  static ResponseHello getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResponseHello>(create);
  static ResponseHello _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get response => $_getSZ(0);
  @$pb.TagNumber(1)
  set response($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearResponse() => clearField(1);
}

