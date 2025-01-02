import 'dart:convert';

import 'package:flutter/material.dart';
import '../pages_structure/pop_up_dialog.dart';
import '../server_socket.dart';
import '../pages_structure/async_state.dart';

class AddInventoryPopup extends BasePopup {
  const AddInventoryPopup({super.key}) : super(1);

  @override
  State<AddInventoryPopup> createState() => _AddInventoryPopupState();
}

class _AddInventoryPopupState extends State<AddInventoryPopup> {
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
    return AlertDialog(
      content: Column(
        spacing: 2.5,
        children: [
          TextField(
            controller: _productNameController,
            decoration: InputDecoration(
              hintText: 'Enter product name',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _itemCodeController,
            decoration: InputDecoration(
              hintText: 'Enter item code',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              hintText: 'Enter product price',
            ),
          ),
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
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
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
        ),
      ],
    );
  }
}
