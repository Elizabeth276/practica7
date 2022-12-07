import 'package:flutter/material.dart';

ThemeData lightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: Colors.grey[100],
    primaryColor: Colors.indigo.shade300,
    primaryColorDark: Colors.teal.shade100,
    secondaryHeaderColor: Colors.amber.shade100,
    primaryColorLight: Colors.black54,
  );
}

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    backgroundColor: Colors.grey[400],
    primaryColor: Colors.blueGrey,
    primaryColorDark: Colors.black87,
    secondaryHeaderColor: Colors.amber.shade100,
    primaryColorLight: Colors.black54,
  );
}
