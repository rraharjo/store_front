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
            backgroundColor: Colors.white,
            content: InventoriesExpansionList(items),
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

class InventoriesExpansionList extends StatefulWidget {
  final List<dynamic> inventories;

  const InventoriesExpansionList(this.inventories, {super.key});

  @override
  State<InventoriesExpansionList> createState() =>
      _InventoriesExpansionListState();
}

class _InventoriesExpansionListState extends State<InventoriesExpansionList> {
  final List<bool> _isOpen = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        dividerColor: themeColor,
        children: List<ExpansionPanel>.generate(
          widget.inventories.length,
          (idx) {
            dynamic curItem = widget.inventories[idx];
            _isOpen.add(false);
            return ExpansionPanel(
              backgroundColor: Colors.white,
              headerBuilder: (context, isOpen) {
                if (!isOpen) {
                  return ListTile(
                    title: Text(
                      curItem["name"],
                      style: h2,
                    ),
                    subtitle: Text(
                      "Price: \$${curItem["price"].toString()}",
                      style: informationTextSytle,
                    ),
                  );
                }
                return Text(
                  curItem["name"],
                  style: h2,
                );
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Database Code: ${curItem["dbcode"]}",
                    style: informationTextSytle,
                  ),
                  Text(
                    "Item Code: ${curItem["item_code"]}",
                    style: informationTextSytle,
                  ),
                  Text(
                    "Name: ${curItem["name"]}",
                    style: informationTextSytle,
                  ),
                  Text(
                    "Price: ${curItem["price"].toString()}",
                    style: informationTextSytle,
                  ),
                ],
              ),
              isExpanded: _isOpen[idx],
            );
          },
        ),
        expansionCallback: (idx, isOpen) {
          setState(() {
            _isOpen[idx] = !_isOpen[idx];
          });
        },
      ),
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
