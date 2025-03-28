import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'message.dart';

import 'package:store_front/pages/message.dart';
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
    InboundMessage inMsg = InboundMessage();
    String toRet = "";
    Timer failingTimer = Timer(Duration(seconds: 5), () {
      Map<String, dynamic> errorMsg = {"status": false};
      toRet = jsonEncode(errorMsg);
    });
    while (!inMsg.complete()) {
      if (sBuffer.isNotEmpty){
        toRet = sBuffer.toString();
        sBuffer.clear();
      }
      await Future.delayed(Duration(milliseconds: 250));
    }
    if (failingTimer.isActive) {
      failingTimer.cancel();
    }
    return toRet;
  }

  Future<String?> write(String argument) async {
    OutboundMessage out = OutboundMessage(argument);
    InboundMessage inMsg = InboundMessage();
    String? toReturn;
    // Connect to the server
    Socket socket = await Socket.connect(_ipAddress, _port);

    // Write a request to the server (optional, depends on your use case)
    socket.write(utf8.decode(out.toStream()));

    // Completer to return the final complete message
    Completer<String> completer = Completer<String>();

    // Listen for incoming data
    socket.listen((List<int> data) {
      // Add incoming data to the buffer
      inMsg.processSegment(Uint8List.fromList(data));

      // If the expected length is known, check if the message is complete
      if (inMsg.complete()) {
        // Combine the buffer and decode the message
        completer.complete(inMsg.getPayloadAsString());
        socket.destroy(); // Close the socket
      }
    }, onDone: () {
      // If the length is not known, return all data in the buffer
        //completer.complete(inMsg.getPayloadAsString());
        socket.destroy(); // Close the socket
    });

    return completer.future;
  }
}
