import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool? _isSignUpScreen = true;

  bool? getIsSignUpScreen() => _isSignUpScreen;

  setIsSiginupScreen(bool isSignUpScreen) {
    this._isSignUpScreen = isSignUpScreen;
    notifyListeners();
  }
}
