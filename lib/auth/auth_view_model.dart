import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String username, String password) {
    // Aquí puedes validar contra tu backend más adelante
    if (username == 'admin' && password == '1234') {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

