import 'package:flutter/material.dart';

class ApplicationTheme{
  static Color primaryColor=Color(0xFF9A1DDB);
  static ThemeData lightTheme=ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor,
  primary: primaryColor));
}