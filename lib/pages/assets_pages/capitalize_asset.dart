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

class ReassessAsset extends BasicPage {
  final Map<String, dynamic> _theAsset;

  const ReassessAsset(this._theAsset, {super.key})
      : super(
          "Reassess Asset",
          const Placeholder(),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: ReassessAssetContent(_theAsset),
    );
  }
}

class ReassessAssetContent extends StatefulWidget {
  final Map<String, dynamic> theAsset;

  const ReassessAssetContent(this.theAsset, {super.key});

  @override
  State<ReassessAssetContent> createState() => _ReassessAssetContentState();
}

class _ReassessAssetContentState extends State<ReassessAssetContent> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cashPaidController = TextEditingController();
  String buttonText = "confirm";

  bool validateAmount() {
    double? amt = double.tryParse(_amountController.value.text);
    double? cashPaid = double.tryParse(_cashPaidController.value.text);
    if (amt == null || cashPaid == null) {
      return false;
    }
    if (amt <= 0 || cashPaid < 0) {
      return false;
    }
    if (amt < cashPaid) {
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
                InfoTile("Name", "${widget.theAsset["name"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Code", "${widget.theAsset["dbcode"]}",
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
                  "Capitalized Amount: \$",
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
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              spacing: 10,
              children: [
                Text(
                  "Cash Paid: \$",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: themeColor),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: TextField(
                    controller: _cashPaidController,
                    decoration: InputDecoration(isDense: true),
                    keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                  ),
                )
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
                  Map<String, dynamic> summary = widget.theAsset;
                  summary["price"] = double.parse(_amountController.value.text);
                  summary["cash_paid"] =
                      double.parse(_cashPaidController.value.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ReassessAssetConfirmation(summary),
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

class ReassessAssetConfirmation extends BasicPage {
  final Map<String, dynamic> _transactionSummary;

  const ReassessAssetConfirmation(this._transactionSummary, {super.key})
      : super(
          "Reassess Asset",
          const Placeholder(),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: ReassessAssetConfirmationContent(_transactionSummary),
    );
  }
}

class ReassessAssetConfirmationContent extends StatefulWidget
    implements HasCommand {
  final Map<String, dynamic> _transactionSummary;

  const ReassessAssetConfirmationContent(this._transactionSummary, {super.key});

  @override
  int getCommand() {
    return 4;
  }

  @override
  State<ReassessAssetConfirmationContent> createState() =>
      _ReassessAssetConfirmationContentState();
}

class _ReassessAssetConfirmationContentState
    extends State<ReassessAssetConfirmationContent> {
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
                InfoTile("Name", widget._transactionSummary["name"],
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Code", widget._transactionSummary["dbcode"],
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile("Value", "\$${widget._transactionSummary["cost"]}",
                    leftInfoColumnFactor, rightInfoColumnFactor),
                InfoTile(
                    "Residual Value",
                    "\$${widget._transactionSummary["residual_value"]}",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile(
                    "Book Value",
                    "\$${widget._transactionSummary["book_value"]}",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile(
                    "Useful Life",
                    "${widget._transactionSummary["useful_life"]} years",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile(
                    "Date Purchased",
                    "${widget._transactionSummary["date_purchased"]}",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
                Text(""),
                InfoTile(
                    "Selling Price",
                    "\$${widget._transactionSummary["price"]}",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
                InfoTile(
                    "Cash Paid",
                    "\$${widget._transactionSummary["cash_paid"]}",
                    leftInfoColumnFactor,
                    rightInfoColumnFactor),
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
                  request["date"] =
                      DateFormat("dd/MM/yyyy").format(DateTime.now());
                  request["dbcode"] = widget._transactionSummary["dbcode"];
                  request["cost"] = widget._transactionSummary["price"];
                  request["paid_cash"] =
                      widget._transactionSummary["cash_paid"];
                  String? resString =
                      await ServerSocket.instance.write(jsonEncode(request));
                  if (resString == null) {
                    setState(() {
                      buttonText = "Failed";
                    });
                  }
                  Map<String, dynamic> response = jsonDecode(resString!);
                  if (response["status"]) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageAssets(),
                      ),
                    );
                  } else {
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
