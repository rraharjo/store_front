import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_front/pages/assets_pages/capitalize_asset.dart';
import 'package:store_front/pages/assets_pages/sell_asset.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

//TODO: Add sell asset
class ManageAssets extends BasicPage {
  const ManageAssets({super.key})
      : super(
          "Manage Assets",
          const ManageAssetsContent(),
        );
}

class ManageAssetsContent extends StatefulWidget implements HasCommand {
  const ManageAssetsContent({super.key});

  @override
  int getCommand() {
    return 9;
  }

  @override
  State<ManageAssetsContent> createState() => _InventoryListState();
}

class _InventoryListState extends State<ManageAssetsContent> {
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
  final TextEditingController _searchController = TextEditingController();
  String pattern = "";
  final List<bool> _isOpen = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> panels = [];
    _isOpen.clear();
    for (dynamic curItem in widget.inventories) {
      String curName = curItem["name"] as String;
      if (curName.startsWith(pattern)) {
        panels.add(Container(
          decoration: BoxDecoration(
            border: Border.all(color: themeColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              curItem["name"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeColor,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(
              curItem["dbcode"],
              style: informationTextSytle,
            ),
            trailing: PopupMenuButton<IconButton>(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<IconButton>>[
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReassessAsset(curItem),
                          ),
                        );
                      },
                      child: Text("Capitalize", style: informationTextSytle),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellAsset(curItem),
                          ),
                        );
                      },
                      child: Text("Sell", style: informationTextSytle),
                    ),
                  )
                ];
              },
              icon: Icon(
                Icons.more,
                color: themeColor,
              ),
            ),
            isThreeLine: true,
          ),
        ));
      }
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        spacing: 10,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
            onChanged: (String newVal) {
              setState(() {
                _isOpen.clear();
                pattern = newVal;
              });
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  spacing: 10,
                  children: panels,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
