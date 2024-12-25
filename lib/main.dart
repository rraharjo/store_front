import 'package:flutter/material.dart';
import './pages/home_page.dart';
import 'dart:io';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: HomePage(),
    ),
  );
}
