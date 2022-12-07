import 'package:flutter/material.dart';

class NewEmployeeProvider with ChangeNotifier {
  String _pathImage = '';
  String _fileName = '';

  String getPathImage() => _pathImage;

  setPathImage(String pathImage) {
    this._pathImage = pathImage;
    notifyListeners();
  }

  String getFileName() => _fileName;

  setFileName(String fileName) {
    this._fileName = fileName;
    notifyListeners();
  }
}
