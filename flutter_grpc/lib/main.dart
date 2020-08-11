import 'package:flutter/material.dart';
import 'package:flutter_grpc/model/shurli.pb.dart';
import 'package:flutter_grpc/services/shurli_service.dart';

void main() => runApp(new FlutterGrpcApp());

class FlutterGrpcApp extends StatefulWidget {
  _FlutterGrpcAppState createState() => _FlutterGrpcAppState();
}

class _FlutterGrpcAppState extends State<FlutterGrpcApp> {
  String resname;

  @override
  void initState() {
    resname = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Grpc ❤️ Flutter"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  onPressed: () async => _walletInfo(),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Let's say hi!",
                    style: TextStyle(color: Colors.white),
                  )),
              resname.isNotEmpty ? Text("Server says: $resname") : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _walletInfo() async {
    var res = await ShurliService.WalletInfo();
    var list = new List(res.wallets.length);
    list = res.wallets;
    print(list[0].name);
    setState(() {
      resname = list[0].name.toString();
    });
  }
}