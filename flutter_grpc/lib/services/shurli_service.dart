import 'package:flutter_grpc/common/grpc_commons.dart';
import 'package:flutter_grpc/model/shurli.pb.dart';
import 'package:flutter_grpc/model/shurli.pbgrpc.dart';

class ShurliService {
  static Future<WalletInfoResponse> WalletInfo() async{
    var client = ShurliServiceClient(GrpcClientSingleton().client);
    return await client.walletInfo(WalletInfoRequest());
  }
}
