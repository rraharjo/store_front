import 'package:flutter/material.dart';
import 'pop_up_dialog.dart';

abstract class GridButton extends StatelessWidget {
  final String desc;
  final IconData iconData;
  final Widget popUpDialog;

  const GridButton(
      {super.key,
      required this.desc,
      required this.iconData,
      required this.popUpDialog});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => popUpDialog);
            },
            child: Icon(
              iconData,
              color: Colors.lightBlue,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: 20,
            ),
            child: FittedBox(
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SampleButton extends GridButton {
  const SampleButton({super.key})
      : super(
            desc: "Sample",
            iconData: Icons.abc,
            popUpDialog: const SamplePopUp());
}
