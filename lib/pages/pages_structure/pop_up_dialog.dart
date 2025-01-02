import 'package:flutter/material.dart';

abstract class BasePopup extends StatefulWidget {
  final int commandNumber;
  final String commandDelimiter = 'ENDCMD';
  const BasePopup(this.commandNumber, {super.key});

  String constructCommand(List<String> arguments){
    String toRet = '$commandNumber ';
    for (String element in arguments) {
      toRet += '"$element" ';
    }
    toRet += commandDelimiter;
    return toRet;
  }
}

class SamplePopUp extends AlertDialog {
  const SamplePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Column(
        children: [
          Text('This is a sample dialog'),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context, 'close'),
            child: const Text('Close')),
      ],
    );
  }
}
