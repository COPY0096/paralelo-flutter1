import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      primaryColor: const Color(0xFF0B6EFE),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFFFF9800),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B6EFE),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(fontSize: 16, color: Color(0xFF212121)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF757575)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF0B6EFE),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B6EFE),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
