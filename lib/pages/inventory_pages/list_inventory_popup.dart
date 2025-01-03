import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../pages_structure/pop_up_dialog.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

class InventoryList extends BasePopup {
  const InventoryList({super.key}) : super(8);

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> request = {
      "main_command": widget.commandNumber,
    };

    return FutureBuilder(
      future: ServerSocket.instance.write(jsonEncode(request)),
      builder: (
        BuildContext _,
        AsyncSnapshot<String?> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            children: const [AsyncWaiting()],
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> jsonResponse = jsonDecode(snapshot.data!);
          if (jsonResponse["status"] == false) {
            return SimpleDialog(
              backgroundColor: Colors.white,
              children: const [AsyncFailed()],
            );
          }
          List<dynamic> items = jsonResponse["body"]["data"];
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: List<Widget>.generate(items.length, (idx) {
                  return InventoryTile(items[idx]);
                }),
              ),
            ),
          );
        } else {
          return SimpleDialog(
            backgroundColor: Colors.white,
            children: const [AsyncFailed()],
          );
        }
      },
    );
  }
}

class InventoryTile extends StatelessWidget {
  final dynamic invInfo;

  const InventoryTile(this.invInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return ListTile(
        title: Text(
          invInfo["name"],
          style: TextStyle(
            color: themeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          invInfo["price"].toString(),
          style: TextStyle(color: themeColor),
        ),
        trailing:
            ElevatedButton(onPressed: () {}, child: Icon(Icons.more_vert)),
      );
    } catch (e) {
      return ListTile();
    }
  }
}
