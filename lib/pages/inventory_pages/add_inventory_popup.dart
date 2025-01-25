import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import '../pages_structure/commands_page.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';

class AddInventory extends BasicPage {
  const AddInventory({super.key}) : super("Add Inventory", const AddInventoryContent());
}

class AddInventoryContent extends HasCommand {
  const AddInventoryContent({super.key}) : super(1);

  @override
  State<AddInventoryContent> createState() => _AddInventoryPopupState();
}

class _AddInventoryPopupState extends State<AddInventoryContent> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _errorMsg = "";
  bool _visibleError = false;

  bool validate() {
    if (_productNameController.value.text.isEmpty) {
      _errorMsg = "Product cannot be empty";
      return false;
    }
    if (_priceController.value.text.isEmpty) {
      _errorMsg = "Price cannot be empty";
      return false;
    }
    try {
      double res = double.parse(_priceController.value.text);
      if (res < 0.0) {
        _errorMsg = "Price cannot be lower than 0";
        return false;
      }
    } catch (_) {
      _errorMsg = "Price is invalid";
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
          SimpleInputField('Enter product name', _productNameController),
          SimpleInputField('Enter item code', _itemCodeController),
          SimpleInputField('Enter price', _priceController),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: _visibleError,
            child: Text(
              _errorMsg,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
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
              Map<String, dynamic> request = {
                "main_command": widget.commandNumber,
                "product_name": _productNameController.value.text,
                "item_code": _itemCodeController.value.text,
                "price": double.parse(_priceController.value.text)
              };
              _productNameController.clear();
              _itemCodeController.clear();
              _priceController.clear();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FutureBuilder(
                      future: ServerSocket.instance.write(jsonEncode(request)),
                      builder: (BuildContext _, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SimpleDialog(
                            backgroundColor: Colors.white,
                            children: const [AsyncWaiting()],
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return SimpleDialog(
                            backgroundColor: Colors.white,
                            children: const [AsyncDone()],
                          );
                        } else {
                          return SimpleDialog(
                            backgroundColor: Colors.white,
                            children: const [AsyncFailed()],
                          );
                        }
                      },
                    );
                  });
            },
            child: Text("Send"),
          )
        ],
      ),
    );
  }
}
