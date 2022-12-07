import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  bool? _isPhotoChanged = false;
  bool? _isAuthGoogle = false;

  bool? getIsPhotoChanged() => _isPhotoChanged;

  setIsPhotoChanged(bool isPhotoChanged) {
    this._isPhotoChanged = isPhotoChanged;
    notifyListeners();
  }

  bool? getIsAuthGoogle() => _isAuthGoogle;

  setIsAuthGoogle(bool isAuthGoogle) {
    this._isAuthGoogle = isAuthGoogle;
    notifyListeners();
  }
}
