// lib/mantenimientos/recursos_humanos/permiso_view_model.dart

import 'package:flutter/material.dart';
import 'permiso_model.dart';
import 'permiso_service.dart';

class PermisoViewModel extends ChangeNotifier {
  final PermisoService _service = PermisoService();
  List<Permiso> permisos = [];
  bool isLoading = false;
  String error = '';

  Future<void> loadPermisos() async {
    isLoading = true;
    notifyListeners();
    try {
      permisos = await _service.getPermisos();
      error = '';
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addPermiso(Permiso permiso) async {
    await _service.addPermiso(permiso);
    await loadPermisos();
  }

  Future<void> updatePermiso(Permiso permiso) async {
    await _service.updatePermiso(permiso);
    await loadPermisos();
  }

  Future<void> deletePermiso(int id) async {
    await _service.deletePermiso(id);
    await loadPermisos();
  }
}
