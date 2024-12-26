import 'package:flutter/material.dart';

abstract class GridButton extends StatelessWidget {
  final String desc;
  final IconData iconData;

  const GridButton({super.key, required this.desc, required this.iconData});

  void onPressed();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Icon(
            iconData,
            color: Colors.lightBlue,
          ),
        ),
        Center(
          child: Text(
            desc,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }
}

class SampleButton extends GridButton {
  const SampleButton({super.key}) : super(desc: "Sample", iconData: Icons.abc);

  @override
  void onPressed() {
    return;
  }
}
