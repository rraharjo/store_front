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

  int _getItemPerRow(BuildContext context, {double minWidthPerItem = 100}){
    double contextWidth = MediaQuery.of(context).size.width;
    return contextWidth ~/ minWidthPerItem;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 10.00,
      mainAxisSpacing: 10.00,
      crossAxisCount: _getItemPerRow(context),
      children: List.generate(buttons.length, _generateButton),
    );
  }
}

