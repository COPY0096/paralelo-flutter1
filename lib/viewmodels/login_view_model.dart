import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _loginMessage = '';
  bool _loginSuccess = false;

  String get loginMessage => _loginMessage;
  bool get loginSuccess => _loginSuccess;

  void login(String username, String password) {
    // Aquí luego puedes usar una API HTTP real
    if (username == 'admin' && password == '1234') {
      _loginMessage = '¡Bienvenido!';
      _loginSuccess = true;
    } else {
      _loginMessage = 'Credenciales inválidas';
      _loginSuccess = false;
    }
    notifyListeners(); // Notifica cambios a la vista
  }
}
