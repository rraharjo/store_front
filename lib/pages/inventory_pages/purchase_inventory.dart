import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

class PurchaseInventories extends BasicPage {
  const PurchaseInventories({super.key}) : super('Purchase Inventories', const PurchaseInventoryPopup());
}


class PurchaseInventoryPopup extends HasCommand {
  const PurchaseInventoryPopup({super.key}) : super(2);

  @override
  State<PurchaseInventoryPopup> createState() => _PurchaseInventoryPopupState();
}

class _PurchaseInventoryPopupState extends State<PurchaseInventoryPopup> {
  final Future<String?> items = ServerSocket.instance.write(jsonEncode({
    "main_command": 8,
  }));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: items,
      builder: (BuildContext _, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AsyncWaiting();
        } else if (snapshot.connectionState == ConnectionState.done) {
          final Map<String, dynamic> response = jsonDecode(snapshot.data!);
          if (response["status"] == false) {
            return AsyncFailed();
          }
          List<dynamic> inventories = response["body"]["data"];
          return InvPopup(inventories);
        } else {
          return AsyncFailed();
        }
      },
    );
  }
}

class InvPopup extends StatefulWidget {
  final List<dynamic> inventories;

  const InvPopup(this.inventories, {super.key});

  @override
  State<InvPopup> createState() => _InvPopupState();
}

class _InvPopupState extends State<InvPopup> {
  final SearchController _searchController = SearchController();
  List<dynamic> chosenInventories =
      <dynamic>[]; //{dbcode, name, price, qty, Controller1, Controller2}
  double total = 0.0;

  bool findItem(String dbcode) {
    for (dynamic d in chosenInventories) {
      if (d["dbcode"] == dbcode) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        spacing: 2.5,
        children: <Widget>[
          SearchAnchor.bar(
            searchController: _searchController,
            suggestionsBuilder: (context, controller) {
              String input = controller.value.text;
              return widget.inventories.where((item) {
                return item["name"].contains(input);
              }).map((item) {
                return TextButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    if (findItem(item["dbcode"])) {
                      return;
                    }
                    TextEditingController priceController =
                        TextEditingController();
                    TextEditingController qtyController =
                        TextEditingController();
                    setState(() {
                      chosenInventories.add({
                        "dbcode": item["dbcode"],
                        "name": item["name"],
                        "price": 0.0,
                        "qty": 0,
                        "price_controller": priceController,
                        "qty_controller": qtyController,
                      });
                    });
                  },
                  child: Text(
                    "${item["dbcode"]} - ${item["name"]}",
                    style: informationTextSytle,
                  ),
                );
              });
            },
          ),
          Text(
            "Total: \$$total",
            style: informationTextSytle,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: TextButton(
              onHover: (hover) {},
              onPressed: () {},
              child: Text("Make Purchase!", style: h2),
            ),
          ),
          //TODO: Rendering error
          /*ListView(
              children: chosenInventories.map(
                (item) {
                  return SizedBox(
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(item["name"]),
                      subtitle: Text(item["dbcode"]),
                      trailing: Row(
                        children: [
                          Text("qty"),
                          Text("price"),
                        ],
                      ),
                    ),
                  );
                },
              ).toList()),*/
        ],
      );
  }
}
