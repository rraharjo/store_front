import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_front/pages/assets_pages/manage_assets.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

class InfoTile extends StatelessWidget {
  final String keyText;
  final String valueText;
  final double leftColFactor;
  final double rightColFactor;

  const InfoTile(
      this.keyText, this.valueText, this.leftColFactor, this.rightColFactor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / leftColFactor,
          child: Text("\t\t\t${keyText}",
              style: TextStyle(fontWeight: FontWeight.bold, color: themeColor)),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / rightColFactor,
          child: Text(
            valueText,
            style: informationTextSytle,
          ),
        ),
      ],
    );
  }
}

class SellAsset extends BasicPage {
  final Map<String, dynamic> _theAsset;

  const SellAsset(this._theAsset, {super.key})
      : super(
          "Sell Asset",
          const Placeholder(),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: SellAssetContent(_theAsset),
    );
  }
}

class SellAssetContent extends StatefulWidget {
  final Map<String, dynamic> theAsset;

  const SellAssetContent(this.theAsset, {super.key});

  @override
  State<SellAssetContent> createState() => _SellAssetContentState();
}

class _SellAssetContentState extends State<SellAssetContent> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cashReceivedController = TextEditingController();
  String buttonText = "confirm";

  bool validateAmount() {
    double? amt = double.tryParse(_amountController.value.text);
    double? cashAmt = double.tryParse(_cashReceivedController.value.text);
    if (amt == null || cashAmt == null) {
      return false;
    }
    if (amt < 0 || cashAmt < 0) {
      return false;
    }
    if (amt < cashAmt) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double leftInfoColumnFactor = 2;
    double rightInfoColumnFactor = 3.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Asset Information:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: themeColor,
                  ),
                ),
                InfoTile("Name", widget.theAsset["name"], leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile("Code", widget.theAsset["dbcode"],
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Value", "\$${widget.theAsset["cost"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile(
                    "Residual Value",
                    "\$${widget.theAsset["residual_value"]}",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile("Book Value", "\$${widget.theAsset["book_value"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile(
                    "Useful Life",
                    "${widget.theAsset["useful_life"]} years",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile(
                    "Date Purchased",
                    "${widget.theAsset["date_purchased"]}",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              spacing: 10,
              children: [
                Text(
                  "Selling Price: \$",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: themeColor),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                    child: TextField(
                      controller: _amountController,
                      decoration: InputDecoration(isDense: true),
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              spacing: 10,
              children: [
                Text(
                  "Cash Received: \$",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: themeColor),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                    child: TextField(
                      controller: _cashReceivedController,
                      decoration: InputDecoration(isDense: true),
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  if (!validateAmount()) {
                    setState(() {
                      buttonText = "Invalid Amount...";
                    });
                    return;
                  }
                  Map<String, dynamic> transactionSummary = widget.theAsset;
                  transactionSummary["price"] =
                      double.parse(_amountController.value.text);
                  transactionSummary["cash_received"] =
                      double.parse(_cashReceivedController.value.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SellAssetConfirmation(transactionSummary),
                    ),
                  );
                },
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class SellAssetConfirmation extends BasicPage {
  final Map<String, dynamic> _transactionSummary;

  const SellAssetConfirmation(this._transactionSummary, {super.key})
      : super(
          "Sell Asset",
          const Placeholder(),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: SellAssetConfirmationContent(_transactionSummary),
    );
  }
}

class SellAssetConfirmationContent extends StatefulWidget
    implements HasCommand {
  final Map<String, dynamic> _transactionSummary;

  const SellAssetConfirmationContent(this._transactionSummary, {super.key});

  @override
  int getCommand() {
    return 6;
  }

  @override
  State<SellAssetConfirmationContent> createState() => _SellAssetConfirmationContentState();
}

class _SellAssetConfirmationContentState extends State<SellAssetConfirmationContent> {
  String buttonText = "Confirm!";

  @override
  Widget build(BuildContext context) {
    double leftInfoColumnFactor = 2;
    double rightInfoColumnFactor = 3;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Asset Information:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: themeColor,
                  ),
                ),
                InfoTile("Name", widget._transactionSummary["name"], leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile("Code", widget._transactionSummary["dbcode"], leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile("Value", "\$${widget._transactionSummary["cost"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Residual Value", "\$${widget._transactionSummary["residual_value"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Book Value", "\$${widget._transactionSummary["book_value"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Useful Life", "${widget._transactionSummary["useful_life"]} years",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Date Purchased", "${widget._transactionSummary["date_purchased"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                Text(""),
                InfoTile("Selling Price", "\$${widget._transactionSummary["price"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Cash Received", "\$${widget._transactionSummary["cash_received"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  Map<String, dynamic> request = <String, dynamic>{};
                  request["main_command"] = widget.getCommand();
                  request["date"] = DateFormat("dd/MM/yyyy").format(DateTime.now());
                  request["dbcode"] = widget._transactionSummary["dbcode"];
                  request["price"] = widget._transactionSummary["price"];
                  request["paid_cash"] = widget._transactionSummary["cash_received"];
                  String? resString = await ServerSocket.instance.write(jsonEncode(request));
                  if (resString == null){
                    setState(() {
                      buttonText = "Failed";
                    });
                  }
                  Map<String,dynamic> response = jsonDecode(resString!);
                  if (response["status"]){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageAssets(),
                      ),
                    );
                  }
                  else{
                    setState(() {
                      buttonText = "Failed";
                    });
                  }
                },
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
