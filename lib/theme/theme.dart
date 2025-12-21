import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(135, 189, 241, 1),
    foregroundColor: Colors.white,
    centerTitle: true,
    toolbarHeight: 80,
  ),
  colorScheme: ColorScheme.light(
    surface: Color.fromRGBO(190, 221, 252, 1),
    primary: Color.fromRGBO(135, 189, 241, 1),
    secondary: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade800,
    foregroundColor: Colors.white,
    centerTitle: true,
    toolbarHeight: 80,
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.white,
  ),
);
