import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages_structure/pop_up_dialog.dart';
import '../server_socket.dart';

class AddInventoryPopup extends BasePopup {
  const AddInventoryPopup({super.key}) : super(1);

  @override
  State<AddInventoryPopup> createState() => _AddInventoryPopupState();
}

class _AddInventoryPopupState extends State<AddInventoryPopup> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
        //TODO: Handle response from server using socket
        TextButton(
          onPressed: () async {
            String command = widget.constructCommand(<String>[
              _productNameController.value.text,
              _itemCodeController.value.text,
              _priceController.value.text
            ]);
            _productNameController.clear();
            _itemCodeController.clear();
            _priceController.clear();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder(
                    future: ServerSocket.instance.write(command),
                    builder: (BuildContext _, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          content: Text("waiting"),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return AlertDialog(
                          content: Text(snapshot.data!),
                        );
                      } else {
                        return AlertDialog(
                          content: Text("Error"),
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
