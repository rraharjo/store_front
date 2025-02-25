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

  int _getItemPerRow(BuildContext context, {double minWidthPerItem = 100}) {
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

class BasicPage extends StatelessWidget {
  final String _title;
  final Widget _content;

  const BasicPage(this._title, this._content, {super.key});

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        _title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: _content,
    );
  }
}

class SampleBasicPage extends BasicPage {
  const SampleBasicPage({super.key})
      : super("sample", const Text("This is a sample"));
}

class SimpleInputField extends StatelessWidget {
  final TextEditingController _controller;
  final String hintText;

  const SimpleInputField(this.hintText, this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }
}

class NumberInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController _controller;
  final bool isInteger;

  const NumberInputField(this._controller,
      {this.isInteger = false, this.hintText = "", super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.numberWithOptions(
        signed: true,
        decimal: isInteger,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }
}
