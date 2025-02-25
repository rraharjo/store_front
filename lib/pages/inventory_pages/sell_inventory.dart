import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

class SellInventories extends BasicPage {
  const SellInventories({super.key})
      : super('Sell Inventories', const SellInventoriesPopup());
}

class SellInventoriesPopup extends StatefulWidget {
  const SellInventoriesPopup({super.key});

  @override
  State<SellInventoriesPopup> createState() => _SellInventoriesPopupState();
}

class _SellInventoriesPopupState extends State<SellInventoriesPopup> {
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
          return SellInventoryPopupContent(inventories);
        } else {
          return AsyncFailed();
        }
      },
    );
  }
}

class SellInventoryPopupContent extends StatefulWidget {
  final List<dynamic> inventories;

  const SellInventoryPopupContent(this.inventories, {super.key});

  @override
  State<SellInventoryPopupContent> createState() =>
      _SellInventoryPopupContentState();
}

class _SellInventoryPopupContentState extends State<SellInventoryPopupContent> {
  final SearchController _searchController = SearchController();
  List<dynamic> chosenItems =
      <dynamic>[]; //{dbcode, name, price, qty, Controller1}
  double total = 0.0;

  bool findItem(String dbcode) {
    for (dynamic d in chosenItems) {
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
                    if (item["qty"] <= 0){
                      return;
                    }
                    if (findItem(item["dbcode"])) {
                      return;
                    }
                    TextEditingController qtyController =
                        TextEditingController();
                    setState(() {
                      chosenItems.add({
                        "dbcode": item["dbcode"],
                        "name": item["name"],
                        "price": item["price"],
                        "max_qty": item["qty"],
                        "qty": 0,
                        "qty_controller": qtyController,
                      });
                      _searchController.closeView(null);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item["dbcode"]} - ${item["name"]}",
                        style: informationTextSytle,
                      ),
                      Text(
                        "\$${item["price"]}, ${item["qty"]} left",
                        style: informationTextSytle,
                      )
                    ],
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
                  chosenItems.length,
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
                                chosenItems[idx]["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(chosenItems[idx]["dbcode"]),
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
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: false,
                                      ),
                                      controller: chosenItems[idx]
                                          ["qty_controller"],
                                      onChanged: (value) {
                                        int? i = int.tryParse(value);
                                        setState(() {
                                          total -= chosenItems[idx]["price"] *
                                              chosenItems[idx]["qty"];
                                          if (i == null || i < 0) {
                                            chosenItems[idx]["qty"] = 0;
                                            chosenItems[idx]["qty_controller"].text = chosenItems[idx]["qty"].toString();
                                          } else if (i > chosenItems[idx]["max_qty"]){
                                            chosenItems[idx]["qty"] = chosenItems[idx]["max_qty"];
                                            chosenItems[idx]["qty_controller"].text = chosenItems[idx]["qty"].toString();
                                          }
                                          else {
                                            chosenItems[idx]["qty"] = i;
                                          }
                                          total += chosenItems[idx]["price"] *
                                              chosenItems[idx]["qty"];
                                        });
                                      },
                                    ),
                                  ),
                                  Text(" @\$${chosenItems[idx]["price"]}")
                                ],
                              ),
                              Text(
                                "Total: \$${chosenItems[idx]["price"] * chosenItems[idx]["qty"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                total -= chosenItems[idx]["price"] *
                                    chosenItems[idx]["qty"];
                                chosenItems.removeAt(idx);
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
            fit: BoxFit.contain,
            child: TextButton(
              onHover: (hover) {},
              onPressed: () async {
                final fromNext = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SaleConfirmationPage(chosenItems)),
                );
                if (fromNext != null) {
                  setState(() {
                    chosenItems.clear();
                    total = 0;
                  });
                }
              },
              child: Text("Make Purchase!", style: h2),
            ),
          ),
        ],
      ),
    );
  }
}

class SaleConfirmationPage extends BasicPage {
  final List<dynamic> summary;

  const SaleConfirmationPage(this.summary, {super.key})
      : super("Confirmation", const Placeholder());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: SaleConfirmationContent(summary),
    );
  }
}

class SaleConfirmationContent extends StatefulWidget implements HasCommand {
  final List<dynamic> summary;

  const SaleConfirmationContent(this.summary, {super.key});

  @override
  int getCommand() {
    return 5;
  }

  @override
  State<SaleConfirmationContent> createState() =>
      _SaleConfirmationContentState();
}

class _SaleConfirmationContentState extends State<SaleConfirmationContent> {
  String buttonText = "Confirm!";
  double paidCash = 0.0;
  double total = 0;
  Map<String, dynamic> request = <String, dynamic>{};
  TextEditingController paidCashController = TextEditingController();

  @override
  void initState() {
    super.initState();
    total = widget.summary.fold(0.0, (double prev, dynamic cur) {
      return prev + (cur["price"] * cur["qty"]);
    });
    request["main_command"] = widget.getCommand();
    request["date"] = DateFormat("dd/MM/yyyy").format(DateTime.now());
    request["items"] = widget.summary.map((e) {
      Map<String, dynamic> singleItem = <String, dynamic>{};
      singleItem["dbcode"] = e["dbcode"];
      singleItem["qty"] = e["qty"];
      return singleItem;
    }).toList();
    request["paid_cash"] = 0.0;
  }

  Widget _generateItemRow(String s1, String s2, String s3, String s4) {
    double spacingWidth = MediaQuery.of(context).size.width * 0.3 * 0.1;
    double itemWidth = MediaQuery.of(context).size.width * 0.9 * 0.6 * 0.25;
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 10, 3, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SizedBox(
              width: itemWidth,
              child: Text(s1),
            ),
            SizedBox(
              width: spacingWidth,
            ),
            SizedBox(
              width: itemWidth,
              child: Text(s2),
            ),
            SizedBox(
              width: spacingWidth,
            ),
            SizedBox(
              width: itemWidth,
              child: Text(s3),
            ),
            SizedBox(
              width: spacingWidth,
            ),
            SizedBox(
              width: itemWidth,
              child: Text(s4),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> generateList() {
    List<Widget> toRet = List<Widget>.empty(growable: true);
    toRet.add(_generateItemRow("name", "code", "qty", "@price"));
    for (int i = 0; i < widget.summary.length; i++) {
      toRet.add(_generateItemRow(
          widget.summary[i]["name"],
          widget.summary[i]["dbcode"],
          widget.summary[i]["qty"].toString(),
          widget.summary[i]["price"].toString()));
    }
    return toRet;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: generateList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Text(
                  "Total: \$",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  total.toString(),
                  style: TextStyle(
                    color: themeColor,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 30, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Text(
                  "Cash Paid: \$",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: TextField(
                  decoration: InputDecoration(isDense: true),
                  keyboardType: TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  controller: paidCashController,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: TextButton(
            onPressed: () async {
              setState(() {
                buttonText = "Executing...";
              });
              double? paidCash;
              paidCash = double.tryParse(paidCashController.value.text);
              if (paidCash == null || paidCash < 0 || paidCash > total) {
                setState(() {
                  buttonText = "Invalid number, try again...";
                });
                return;
              }
              request["paid_cash"] = paidCash;
              String requestString = jsonEncode(request);
              String? result = await ServerSocket.instance.write(requestString);
              if (result != null) {
                Map<String, dynamic> response = jsonDecode(result);
                if (response["status"]) {
                  setState(() {
                    buttonText = "Success!";
                  });
                  Navigator.pop(context, "reset");
                  Navigator.pop(context, "reset");
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SellInventories()));
                  return;
                } else {
                  setState(() {
                    buttonText = "Failed, try again later...";
                  });
                  return;
                }
              } else {
                setState(() {
                  buttonText = "Failed, try again...";
                });
                return;
              }
            },
            child: Text(
              buttonText,
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
