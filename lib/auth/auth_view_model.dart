import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoggedIn = true;

  void logout() {
    // Limpiar tokens...
    isLoggedIn = false;
    notifyListeners();
  }
}

