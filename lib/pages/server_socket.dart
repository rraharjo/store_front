import 'dart:async';
import 'dart:io';

class ServerSocket {
  static ServerSocket? _instance;
  static final String _ipAddress = "127.0.0.1";
  static final int _port = 8000;
  Completer<String> completer = Completer<String>();
  Socket? serverSock;

  ServerSocket._internal();

  static ServerSocket get instance {
    _instance ??= ServerSocket._internal();
    return _instance!;
  }

  Future<String> _read() async {
    return completer.future;
  }

  Future<bool> connect() async {
    try {
      if (serverSock == null) {
        serverSock = await Socket.connect(_ipAddress, _port);
        serverSock!.listen((data) {
          if (!completer.isCompleted) {
            completer.complete(String.fromCharCodes(data));
          }
        });
      }
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<String?> write(String argument) async {
    String? toRet = "";
    serverSock!.write(argument);
    toRet = await _read();
    return toRet;
  }
}
