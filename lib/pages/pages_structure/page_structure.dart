import 'package:flutter/material.dart';


abstract class MainGrid extends StatelessWidget {
  final List<Widget> buttons = <Widget>[];
  final Color iconColor = Colors.lightBlue;

  void addButtons();

  MainGrid({super.key}) {
    addButtons();
  }

  Widget _generateButton(int index) {
    return buttons[index];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 30.00,
      mainAxisSpacing: 30.00,
      crossAxisCount: 3,
      children: List.generate(buttons.length, _generateButton),
    );
  }
}

