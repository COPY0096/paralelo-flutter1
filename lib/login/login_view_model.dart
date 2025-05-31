import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../auth/auth_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  String _message = '';
  String get message => _message;

  // Nuevo método login que retorna Future<bool>
  Future<bool> login(String username, String password) async {
    //final url = Uri.parse('http://10.0.2.2:3000/api/auth/login');
    final url = Uri.parse('http://10.0.2.2:3000/api/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        _message = '¡Login exitoso!';
        notifyListeners();
        return true;
      }
    }
    _message = 'Credenciales inválidas';
    notifyListeners();
    return false;
  }

  // Método para usar en la vista, con navegación y AuthViewModel
  Future<void> loginAndNavigate(BuildContext context, String username, String password) async {
    final success = await login(username, password);
    if (success) {
      context.read<AuthViewModel>().login();
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}