import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './pages/constant.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: const TextStyle(
            fontSize: 20,
          ),
          displaySmall: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          labelMedium: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          labelSmall: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            iconSize: 30,
            backgroundColor: Colors.white,
            shape: CircleBorder(),
            minimumSize: Size(50, 50),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(backgroundColor: themeColor)
      ),
      home: HomePage(),
    ),
  );
}
