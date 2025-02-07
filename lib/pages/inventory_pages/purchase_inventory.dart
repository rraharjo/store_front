import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

class PurchaseInventories extends BasicPage {
  const PurchaseInventories({super.key})
      : super('Purchase Inventories', const PurchaseInventoryPopup());
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
  //TODO: fix this to Map
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
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        spacing: 2.5,
        children: <Widget>[
          SearchAnchor.bar(
            barHintText: "Search name, unique code",
            searchController: _searchController,
            suggestionsBuilder: (context, controller) {
              String input = controller.value.text;
              return widget.inventories.where((item) {
                return item["name"].contains(input) ||
                    item["dbcode"].contains(input);
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
                      _searchController.closeView(null);
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                children: List<Widget>.generate(
                  chosenInventories.length,
                  (idx) {
                    return Material(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ListTile(
                          tileColor: Colors.white,
                          leading: Text(
                            "${idx + 1}",
                            style: TextStyle(fontSize: 24),
                          ),
                          textColor: themeColor,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chosenInventories[idx]["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(chosenInventories[idx]["dbcode"]),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Qty "),
                                  SizedBox(
                                    width: 40.00,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.numberWithOptions(
                                        signed: true,
                                        decimal: true,
                                      ),
                                      controller: chosenInventories[idx]
                                          ["price_controller"],
                                      onChanged: (value) {
                                        int? i = int.tryParse(value);
                                        setState(() {
                                          total -= chosenInventories[idx]["price"] * chosenInventories[idx]["qty"];
                                          if (i == null || i < 0) {
                                            chosenInventories[idx]["qty"] = 0;
                                          } else {
                                            chosenInventories[idx]["qty"] = i;
                                          }
                                          total += chosenInventories[idx]["price"] * chosenInventories[idx]["qty"];
                                        });
                                      },
                                    ),
                                  ),
                                  Text("\$ "),
                                  SizedBox(
                                    width: 40.00,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        isDense: true,
                                      ),
                                      controller: chosenInventories[idx]
                                          ["qty_controller"],
                                      onChanged: (value) {
                                        double? d = double.tryParse(value);
                                        setState(() {
                                          total -= chosenInventories[idx]["price"] * chosenInventories[idx]["qty"];
                                          if (d == null || d < 0.0) {
                                            chosenInventories[idx]["price"] = 0.0;
                                          } else {
                                            chosenInventories[idx]["price"] = d;
                                          }
                                          total += chosenInventories[idx]["price"] * chosenInventories[idx]["qty"];
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Total: \$${chosenInventories[idx]["price"] * chosenInventories[idx]["qty"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                total -= chosenInventories[idx]["price"] * chosenInventories[idx]["qty"];
                                chosenInventories.removeAt(idx);
                              });
                            },
                            icon: Icon(
                              Icons.delete_rounded,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Text(
            "Total: \$$total",
            style: TextStyle(fontWeight: FontWeight.bold, color: themeColor),
          ),
          FittedBox(
            //TODO: execute the order
            fit: BoxFit.contain,
            child: TextButton(
              onHover: (hover) {},
              onPressed: () {
              },
              child: Text("Make Purchase!", style: h2),
            ),
          ),
        ],
      ),
    );
  }
}


//TODO fix confirmation page
class PurchaseConfirmation extends StatefulWidget {
  final Map<String, dynamic> summary;
  const PurchaseConfirmation(this.summary,  {super.key});

  @override
  State<PurchaseConfirmation> createState() => _PurchaseConfirmationState();
}

class _PurchaseConfirmationState extends State<PurchaseConfirmation> {
  List<Widget> generateList(){
    List<Widget> toRet = List<Widget>.empty();
    widget.summary.forEach((k, v) {
      toRet.add(ListTile(

      ));
    });
    return List<Widget>.empty();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back)),
      ),
      persistentFooterButtons: [

      ],
    );
  }
}
