import 'package:flutter/material.dart';
import 'package:practica7/settings/styles_settings.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme();
  //ThemeData _themeData = darkTheme();

  getThemeData() => _themeData;

  setthemData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
