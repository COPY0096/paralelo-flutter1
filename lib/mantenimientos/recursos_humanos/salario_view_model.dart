// lib/mantenimientos/recursos_humanos/salario_view_model.dart

import 'package:flutter/material.dart';
import 'salario_model.dart';
import 'salario_service.dart';

class SalarioViewModel extends ChangeNotifier {
  final SalarioService _service = SalarioService();
  List<Salario> _salarios = [];
  bool _isLoading = false;
  String _error = '';

  List<Salario> get salarios => _salarios;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadSalarios({int? usuarioId}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _salarios = await _service.fetchSalarios(usuarioId: usuarioId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSalario(Salario salario) async {
    try {
      await _service.createSalario(salario);
      await loadSalarios(); // recargar
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateSalario(Salario salario) async {
    if (salario.id == null) return;
    try {
      await _service.updateSalario(salario.id!, salario);
      await loadSalarios();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteSalario(int id) async {
    try {
      await _service.deleteSalario(id);
      await loadSalarios();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
