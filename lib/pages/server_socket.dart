import 'dart:async';
import 'dart:io';

class ServerSocket {
  static ServerSocket? _instance;
  static final String _ipAddress = "127.0.0.1";
  static final int _port = 8000;
  Socket? serverSock;

  ServerSocket._internal();

  static ServerSocket get instance {
    _instance ??= ServerSocket._internal();
    return _instance!;
  }

  Future<bool> connect() async {
    try {
      if (serverSock == null){
        serverSock ??= await Socket.connect(_ipAddress, _port);
        serverSock!.listen((data) {
          String toRet = String.fromCharCodes(data);
          print(toRet);});
      }
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<String> _read() async {
    return "";
  }

  Future<String> write(String argument) async {
    String toRet = "";
    serverSock!.write(argument);

    /*try {
      Timer timer = Timer(
          Duration(seconds: 5), () => throw TimeoutException("Server timeout"));
      toRet = await _read();
      print('Socket: $toRet');
      timer.cancel();
    } on TimeoutException catch (_) {
      return "Timeout";
    } catch (_) {
      return "Timeout";
    }*/
    return toRet;
  }
}
