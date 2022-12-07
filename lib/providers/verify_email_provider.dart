import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailProvider with ChangeNotifier {
  bool? _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  bool? getIsEmailVerified() => _isEmailVerified;

  setIsEmailVerified(bool isEmailVerified) {
    this._isEmailVerified = isEmailVerified;
    notifyListeners();
  }
}
