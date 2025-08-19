// auth_view_model.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserModel? _user;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;
  String get username => _user?.username ?? '';
  String get nombre => _user?.nombre ?? '';
  String get correo => _user?.correo ?? '';
  String get rol     => _user?.rol ?? 'invitado';

  /// Realiza login guardando el objeto [UserModel]
  void login(UserModel usuario) {
    _isLoggedIn = true;
    _user = usuario;
    notifyListeners();
  }

  /// Cierra sesión y limpia los datos del usuario
  void logout() {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}
