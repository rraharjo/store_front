import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_front/pages/constant.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';

class AddAsset extends BasicPage {
  const AddAsset({super.key}) : super("Add Asset", const AddAssetContent());
}

class AddAssetContent extends StatefulWidget {
  const AddAssetContent({super.key});

  @override
  State<AddAssetContent> createState() => _AddInventoryPopupState();
}

class _AddInventoryPopupState extends State<AddAssetContent> {
  final TextEditingController _assetNameController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _residualPriceController =
      TextEditingController();
  final TextEditingController _lifeExpectancyController =
      TextEditingController();
  String _errorMsg = "";
  bool _visibleError = false;

  bool validate() {
    if (_assetNameController.value.text.isEmpty) {
      _errorMsg = "Product name cannot be empty";
      return false;
    }
    if (_itemCodeController.value.text.isEmpty) {
      _errorMsg = "Item code cannot be empty";
      return false;
    }
    double? price = double.tryParse(_priceController.value.text);
    double? residual = double.tryParse(_residualPriceController.value.text);
    int? years = int.tryParse(_lifeExpectancyController.value.text);
    if (price == null || price < 0.0) {
      _errorMsg = "invalid price";
      return false;
    }
    if (residual == null || residual < 0.0) {
      _errorMsg = "invalid residual";
      return false;
    }
    if (years == null || residual < 0) {
      _errorMsg = "invalid life";
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        spacing: 2.5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Asset name: ",
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: SimpleInputField("", _assetNameController),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Item code: ",
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: SimpleInputField("", _itemCodeController),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Price: ",
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: NumberInputField(_priceController),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Residual price: ",
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: NumberInputField(_residualPriceController),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Life: ",
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: NumberInputField(
                  _lifeExpectancyController,
                  hintText: "years",
                  isInteger: true,
                ),
              ),
            ],
          ),
          Visibility(
            visible: _visibleError,
            child: Text(
              _errorMsg,
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              bool isValid = validate();
              if (isValid) {
                setState(() {
                  _visibleError = false;
                });
              } else {
                setState(() {
                  _errorMsg = _errorMsg;
                  _visibleError = true;
                });
                return;
              }
              String name = _assetNameController.value.text;
              String itemCode = _itemCodeController.value.text;
              double price = double.parse(_priceController.value.text);
              double residualPrice =
                  double.parse(_residualPriceController.value.text);
              int lifeExpectancy =
                  int.parse(_lifeExpectancyController.value.text);
              final fromNext = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddAssetConfirmation(
                        name, itemCode, price, residualPrice, lifeExpectancy)),
              );
              if (fromNext != null) {
                setState(() {
                  _assetNameController.clear();
                  _itemCodeController.clear();
                  _priceController.clear();
                  _residualPriceController.clear();
                  _lifeExpectancyController.clear();
                });
              }
            },
            child: Text(
              "Send",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AddAssetConfirmation extends BasicPage {
  final String name;
  final String itemCode;
  final double price;
  final double residualPrice;
  final int lifeExpectancy;

  const AddAssetConfirmation(this.name, this.itemCode, this.price,
      this.residualPrice, this.lifeExpectancy,
      {super.key})
      : super("Confirmation", const Placeholder());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: AddAssetConfirmationContent(
          name, itemCode, price, residualPrice, lifeExpectancy),
    );
  }
}

class AddAssetConfirmationContent extends StatefulWidget implements HasCommand {
  final String name;
  final String itemCode;
  final double price;
  final double residualPrice;
  final int lifeExpectancy;

  const AddAssetConfirmationContent(this.name, this.itemCode, this.price,
      this.residualPrice, this.lifeExpectancy,
      {super.key});

  @override
  int getCommand() {
    return 3;
  }

  @override
  State<AddAssetConfirmationContent> createState() =>
      _AddAssetConfirmationContentState();
}

class _AddAssetConfirmationContentState
    extends State<AddAssetConfirmationContent> {
  final TextEditingController _cashPaidController = TextEditingController();
  String buttonMsg = "Submit";
  Map<String, dynamic> request = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    request["main_command"] = widget.getCommand();
    request["date"] = DateFormat("dd/MM/yyyy").format(DateTime.now());
    request["name"] = widget.name;
    request["item_code"] = widget.itemCode;
    request["cost"] = widget.price;
    request["residual_value"] = widget.residualPrice;
    request["useful_life"] = widget.lifeExpectancy;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        spacing: 1.5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Name",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(widget.name),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Item Code",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(widget.itemCode),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Price",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text("\$${widget.price}"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Residual Price",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text("\$${widget.residualPrice}"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Life",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text("${widget.lifeExpectancy} yrs"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(
                  "Cash Paid: \$",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: NumberInputField(
                  _cashPaidController,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              double? cashPaid =
                  double.tryParse(_cashPaidController.value.text);
              if (cashPaid == null || cashPaid < 0 || cashPaid > widget.price) {
                setState(() {
                  buttonMsg = "Invalid amount";
                });
                return;
              }
              request["paid_cash"] = cashPaid;
              String requestString = jsonEncode(request);
              String? result = await ServerSocket.instance.write(requestString);
              if (result != null) {
                Map<String, dynamic> response = jsonDecode(result);
                if (response["status"]) {
                  setState(() {
                    buttonMsg = "Success!";
                  });
                  Navigator.pop(context, "reset");
                  return;
                } else {
                  setState(() {
                    buttonMsg = "Failed, try again...";
                  });
                  return;
                }
              } else {
                setState(() {
                  buttonMsg = "Failed, try again...";
                });
                return;
              }
            },
            child: Text(
              buttonMsg,
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
