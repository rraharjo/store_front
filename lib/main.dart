import 'package:flutter/material.dart';
import './pages/home_page.dart';


void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: const TextStyle(
              fontSize: 18,
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            iconSize: 30,
            backgroundColor: Colors.white,

          ),
        ),
      ),
      home: HomePage(),
    ),
  );
}
