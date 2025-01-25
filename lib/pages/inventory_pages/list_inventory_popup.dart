import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

class InventoriesList extends BasicPage {
  const InventoriesList({super.key})
      : super(
          "Inventories List",
          const InventoryListContent(),
        );
}

class InventoryListContent extends HasCommand {
  const InventoryListContent({super.key}) : super(8);

  @override
  State<InventoryListContent> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryListContent> {
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
          return AsyncWaiting();
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> jsonResponse = jsonDecode(snapshot.data!);
          if (jsonResponse["status"] == false) {
            return AsyncFailed();
          }
          List<dynamic> items = jsonResponse["body"]["data"];
          return InventoriesExpansionList(items);
        } else {
          return AsyncFailed();
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
      ),
    );
  }
}
