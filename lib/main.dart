import 'package:flutter/material.dart';
import 'package:newflutterapp/main_detail.dart';
import 'package:newflutterapp/socket_provider.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [ChangeNotifierProvider<SocketProvider>.value(value: SocketProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listMsg = [];
  IO.Socket socket;
  SocketProvider _socketProvider;

  int projectId = 5337;
  String socioToken =  'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYmViYXMtc20uczQ1LmluOjgxMDAvcHcvdXNlci9sb2dpbiIsImlhdCI6MTU4ODkwNDQwMiwiZXhwIjoxNTg4OTM1NTQyLCJuYmYiOjE1ODg5MDQ0MDIsImp0aSI6Im8wTGx4a0N5Nm4rdDFya2JXWFovYVdCemJGSndURERSNVkwTDB3WkVqN1E9Iiwic3ViIjo2Mjg3LCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIiwiZGF0YSI6eyJ1c2VyX2lkIjo2Mjg3LCJuYW1lIjoiTGVzbGV5IEpvaG4iLCJwcm9qZWN0cyI6WzU1MTgsMCw1MzM3LDU1MjldLCJkZWZhdWx0X3Byb2plY3QiOjU1MTgsImxldmVscyI6W3sicHJvamVjdCI6NTUxOCwibGV2ZWwiOiJhZ2VudCJ9LHsicHJvamVjdCI6MCwibGV2ZWwiOiJhZ2VudCJ9LHsicHJvamVjdCI6NTMzNywibGV2ZWwiOiJhZ2VudCJ9LHsicHJvamVjdCI6NTUyOSwibGV2ZWwiOiJhZ2VudCJ9XSwiY2hhbm5lbHMiOlt7InByb2plY3QiOjU1MTgsIml0ZW1zIjpbImZhY2Vib29rIiwidHdpdHRlciIsImluc3RhZ3JhbSIsImVtYWlsIl19LHsicHJvamVjdCI6MCwiaXRlbXMiOlsiZmFjZWJvb2siLCJ0d2l0dGVyIiwiaW5zdGFncmFtIiwiZW1haWwiXX0seyJwcm9qZWN0Ijo1MzM3LCJpdGVtcyI6WyJmYWNlYm9vayIsInR3aXR0ZXIiLCJpbnN0YWdyYW0iLCJlbWFpbCJdfSx7InByb2plY3QiOjU1MjksIml0ZW1zIjpbImZhY2Vib29rIiwidHdpdHRlciIsImluc3RhZ3JhbSIsImVtYWlsIl19XSwiYWxsX3Byb2plY3RzIjpbeyJwcm9qZWN0Ijo1NTE4LCJsZXZlbCI6ImFnZW50IiwiaW5pdGlhbCI6IiJ9LHsicHJvamVjdCI6MCwibGV2ZWwiOiJhZ2VudCIsImluaXRpYWwiOiIifSx7InByb2plY3QiOjUzMzcsImxldmVsIjoiYWdlbnQiLCJpbml0aWFsIjoiIn0seyJwcm9qZWN0Ijo1NTI5LCJsZXZlbCI6ImFnZW50IiwiaW5pdGlhbCI6IiJ9XSwiaXNfYWRtaW4iOmZhbHNlLCJjbGllbnRfaWQiOjU3NjgsInRpbWV6b25lIjoiQXNpYS9KYWthcnRhIiwiaXNfcHciOnRydWV9fQ.LVScsO3AL2R5Edy2hohSKVg-4p4ea3meZXKEb45XWi0';
  String shifId = 'Z4jmbAkrwJQK58DvK16XRde3YMlLVpGx';
  String socket_url = 'https://push-sm.s45.in';

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  _initSocket() async {

    socket = IO.io("$socket_url", <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        "token": "$socioToken",
        "shift_id": '$shifId',
      }
    });

    print('SOCKET_CONNECTION_STATUS : ${socket.connected}');

    socket.on('connect', (data) {
      print('SOCKET_CONNECTED: $data');
      socket.emit("project", projectId);
    });

    socket.on('connect_timeout', (data){
      print('SOCKET_TIMEOUT');
      print('SOCKET_TRY_CONNECTING AGAIN');
    });
    socket.on('connect_error', (data){
      print('SOCKET_CONNECT_ERROR');
    });
    socket.on('reconnect', (data){
      print('SOCKET_RECONNECT');
    });
    socket.on('connecting', (data){
      print('SOCKET_CONNECTING');
    });

    socket.on('hello', (data) {
      print('SOCKET : $data');
      if (data["section"] == "newcomment" ||
          data["section"] == "unlock_ticket" ||
          data["section"] == "read_ticket" ||
          data["section"] == "close") {
        //TICKETS
        print('SOCKET_ENTRY: $data');
        listMsg.add(data["data"]["content"]);
        _socketProvider.setSocketData(value: data);
        setState(() {});
      }
    });

  }

  _socketPing() {
    socket.on('ping', (data){
      print('SOCKET_PING');
    });
  }

  @override
  Widget build(BuildContext context) {
    _socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: listMsg.length * 20.0,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Text("${listMsg[index]}");
            },
            itemCount: listMsg.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainDetail()));
//        _socketPing();
      }),
    );
  }
}
