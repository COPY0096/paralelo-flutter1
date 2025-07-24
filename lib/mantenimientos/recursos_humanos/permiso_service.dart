// lib/mantenimientos/recursos_humanos/permiso_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'permiso_model.dart';

class PermisoService {
  final String baseUrl = 'http://10.0.2.2:3000/api/permisos';

  Future<List<Permiso>> getPermisos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Permiso.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener permisos');
    }
  }

  Future<void> addPermiso(Permiso permiso) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(permiso.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al agregar permiso');
    }
  }

  Future<void> updatePermiso(Permiso permiso) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${permiso.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(permiso.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar permiso');
    }
  }

  Future<void> deletePermiso(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar permiso');
    }
  }
}
