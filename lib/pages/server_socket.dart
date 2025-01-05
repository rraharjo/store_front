import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

String sampleJson = "{\"status\":true,\"body\":{\"data\":[]}}";

class ServerSocket {
  static ServerSocket? _instance;
  static final String _ipAddress = "127.0.0.1";
  static final int _port = 8000;
  StringBuffer sBuffer = StringBuffer();
  Socket? serverSock;

  ServerSocket._internal();

  static ServerSocket get instance {
    _instance ??= ServerSocket._internal();
    return _instance!;
  }

  Future<String> _read() async {
    String toRet = "";
    Timer failingTimer = Timer(Duration(seconds: 5), () {
      Map<String, dynamic> errorMsg = {"status": false};
      toRet = jsonEncode(errorMsg);
    });
    while (toRet == "") {
      await Future.delayed(
        Duration(milliseconds: 250),
        () {
          toRet = toRet == "" ? sBuffer.toString() : toRet;
        },
      );
    }
    sBuffer.clear();
    if (failingTimer.isActive) {
      failingTimer.cancel();
    }
    return toRet;
  }

  Future<bool> connect() async {
    try {
      if (serverSock == null) {
        serverSock = await Socket.connect(_ipAddress, _port);
        serverSock!.listen((data) {
          sBuffer.write(String.fromCharCodes(data));
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
