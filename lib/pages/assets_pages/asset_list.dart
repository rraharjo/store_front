import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

class AssetsList extends BasicPage {
  const AssetsList({super.key})
      : super(
          "Asset List",
          const AssetsListContent(),
        );
}

class AssetsListContent extends StatefulWidget implements HasCommand {
  const AssetsListContent({super.key});

  @override
  int getCommand(){
    return 9;
  }

  @override
  State<AssetsListContent> createState() => _InventoryListState();
}

class _InventoryListState extends State<AssetsListContent> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> request = {
      "main_command": widget.getCommand(),
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
                        "${curItem["dbcode"]}",
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
                      "Name: ${curItem["name"]}",
                      style: informationTextSytle,
                    ),
                    Text(
                      "Value: \$${curItem["cost"].toString()}",
                      style: informationTextSytle,
                    ),
                    Text(
                      "Residual Value: \$${curItem["residual_value"].toString()}",
                      style: informationTextSytle,
                    ),
                    Text(
                      "Book Value: \$${curItem["book_value"].toString()}",
                      style: informationTextSytle,
                    ),
                    Text(
                      "Lifespan: ${curItem["useful_life"].toString()} yrs",
                      style: informationTextSytle,
                    ),
                    Text(
                      "Purchase Date: ${curItem["date_purchased"]}",
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
