// lib/login/login_view_model.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/auth_view_model.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  String _message = '';
  String get message => _message;

  /// Retorna un [UserModel] si el login fue exitoso, o null en caso contrario.
  Future<UserModel?> login(String username, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // El backend devuelve el objeto en la clave 'user'
        final userJson = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userJson);
        _message = '¡Login exitoso!';
        notifyListeners();
        return user;
      }
    }

    _message = 'Credenciales inválidas';
    notifyListeners();
    return null;
  }

  /// Realiza login y navega a la pantalla '/home' si es exitoso.
  Future<void> loginAndNavigate(BuildContext context, String username, String password) async {
    final user = await login(username, password);
    if (user != null) {
      // Guardar usuario completo en AuthViewModel
      context.read<AuthViewModel>().login(user);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// Login con GitHub usando URL Launcher
  Future<void> loginWithGitHub() async {
    const url = 'http://10.0.2.2:3000/auth/github';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      _message = 'No se pudo abrir el navegador';
      notifyListeners();
    }
  }
}