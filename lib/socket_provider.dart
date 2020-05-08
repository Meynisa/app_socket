import 'package:flutter/material.dart';

class SocketProvider extends ChangeNotifier {
  dynamic _socketData = '';

  dynamic get socketData => _socketData;

  void setSocketData({value = ""}) {
    print('SOCKET DATA UPDATE: $value');
    _socketData = value;
    notifyListeners();
  }

}