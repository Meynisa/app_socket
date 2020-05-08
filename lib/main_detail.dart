import 'package:flutter/material.dart';
import 'package:newflutterapp/socket_provider.dart';
import 'package:newflutterapp/string.dart';
import 'package:provider/provider.dart';

class MainDetail extends StatefulWidget {
  @override
  _MainDetailState createState() => _MainDetailState();
}

class _MainDetailState extends State<MainDetail> {
  SocketProvider _socketProvider;
  List<String> listMsg = [];

  _proceedSocket(){
    var data = _socketProvider.socketData;
    if (data["section"] == "newcomment") {
      //TICKETS
      print('SOCKET_ENTRY: $data');
      listMsg.add(data["data"]["content"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    _socketProvider = Provider.of<SocketProvider>(context);
    _proceedSocket();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('${listMsg.length != 0 ? listMsg.last : ''}'),
      ),
    );
  }
}
