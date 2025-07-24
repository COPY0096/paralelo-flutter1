// lib/mantenimientos/recursos_humanos/vacaciones_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vacaciones_model.dart';

class VacacionesService {
  final String baseUrl = 'http://10.0.2.2:3000/api/vacaciones';

  Future<List<Vacaciones>> getVacaciones() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Vacaciones.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener vacaciones');
    }
  }

  Future<void> addVacaciones(Vacaciones vac) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vac.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al agregar vacaciones');
    }
  }

  Future<void> updateVacaciones(Vacaciones vac) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${vac.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vac.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar vacaciones');
    }
  }

  Future<void> deleteVacaciones(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar vacaciones');
    }
  }
}
