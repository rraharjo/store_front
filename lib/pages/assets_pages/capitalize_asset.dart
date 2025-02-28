import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_front/pages/assets_pages/manage_assets.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';
import '../constant.dart';

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

class ReassessAssetContent extends StatefulWidget implements HasCommand{
  final Map<String, dynamic> theAsset;

  const ReassessAssetContent(this.theAsset, {super.key});

  @override
  State<ReassessAssetContent> createState() => _InventoryListState();

  @override
  int getCommand() {
    return 4;
  }
}

class _InventoryListState extends State<ReassessAssetContent> {
  final TextEditingController _amountController = TextEditingController();
  String buttonText = "confirm";
  bool validateAmount(){
    double? amt = double.tryParse(_amountController.value.text);
    if (amt == null){
      return false;
    }
    if (amt <= 0){
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          leftInfoColumnFactor,
                      child: Text("\t\t\tName",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: themeColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          rightInfoColumnFactor,
                      child: Text(
                        "${widget.theAsset["name"]}",
                        style: informationTextSytle,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          leftInfoColumnFactor,
                      child: Text("\t\t\tCode",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: themeColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          rightInfoColumnFactor,
                      child: Text(
                        "${widget.theAsset["dbcode"]}",
                        style: informationTextSytle,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          leftInfoColumnFactor,
                      child: Text("\t\t\tValue",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: themeColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          rightInfoColumnFactor,
                      child: Text(
                        "\$${widget.theAsset["cost"]}",
                        style: informationTextSytle,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          leftInfoColumnFactor,
                      child: Text("\t\t\tResidual Value",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: themeColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          rightInfoColumnFactor,
                      child: Text(
                        "\$${widget.theAsset["residual_value"]}",
                        style: informationTextSytle,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          leftInfoColumnFactor,
                      child: Text("\t\t\tBook Value",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: themeColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          rightInfoColumnFactor,
                      child: Text(
                        "\$${widget.theAsset["book_value"]}",
                        style: informationTextSytle,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          leftInfoColumnFactor,
                      child: Text("\t\t\tUseful Life",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: themeColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          rightInfoColumnFactor,
                      child: Text(
                        "${widget.theAsset["useful_life"]} years",
                        style: informationTextSytle,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          leftInfoColumnFactor,
                      child: Text("\t\t\tDate Purchased",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: themeColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /
                          rightInfoColumnFactor,
                      child: Text(
                        "${widget.theAsset["date_purchased"]}",
                        style: informationTextSytle,
                      ),
                    ),
                  ],
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
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    if (!validateAmount()){
                      setState(() {
                        buttonText = "Invalid Amount...";
                      });
                      return;
                    }
                    Map<String, dynamic> request = {
                      "main_command": widget.getCommand(),
                      "date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
                      "dbcode": widget.theAsset["dbcode"],
                      "cost": double.parse(_amountController.value.text),
                      "paid_cash": 0,
                    };
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
                  ))
            ],
          )
        ],
      ),
    );
  }
}
