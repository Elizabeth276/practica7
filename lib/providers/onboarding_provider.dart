import 'package:flutter/material.dart';

class OnboardingProvider with ChangeNotifier {
  int _actualPage = 0;

  int getActualPage() => _actualPage;

  setPaginaActual(int actualPage) {
    this._actualPage = actualPage;
    notifyListeners();
  }
}
