// lib/mantenimientos/recursos_humanos/vacaciones_view_model.dart

import 'package:flutter/material.dart';
import 'vacaciones_model.dart';
import 'vacaciones_service.dart';

class VacacionesViewModel extends ChangeNotifier {
  final VacacionesService _service = VacacionesService();
  List<Vacaciones> lista = [];
  bool isLoading = false;
  String error = '';

  Future<void> cargarVacaciones() async {
    isLoading = true;
    notifyListeners();
    try {
      lista = await _service.getVacaciones();
      error = '';
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> agregarVacaciones(Vacaciones vac) async {
    await _service.addVacaciones(vac);
    await cargarVacaciones();
  }

  Future<void> actualizarVacaciones(Vacaciones vac) async {
    await _service.updateVacaciones(vac);
    await cargarVacaciones();
  }

  Future<void> eliminarVacaciones(int id) async {
    await _service.deleteVacaciones(id);
    await cargarVacaciones();
  }
}
