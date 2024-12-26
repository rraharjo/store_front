import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorText;
  const ErrorPage(this.errorText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Error"),
      ),
    );
  }
}
