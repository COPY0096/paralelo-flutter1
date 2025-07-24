// lib/mantenimientos/recursos_humanos/salario_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'salario_model.dart';

class SalarioService {
  final String baseUrl = 'http://10.0.2.2:3000/api/salarios';

  Future<List<Salario>> fetchSalarios({int? usuarioId}) async {
    final uri = usuarioId != null
        ? Uri.parse('$baseUrl?usuario_id=$usuarioId')
        : Uri.parse(baseUrl);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Salario.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener salarios');
    }
  }

  Future<Salario> createSalario(Salario salario) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(salario.toJson()),
    );
    if (response.statusCode == 200) {
      return Salario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear salario');
    }
  }

  Future<Salario> updateSalario(int id, Salario salario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(salario.toJson()),
    );
    if (response.statusCode == 200) {
      return Salario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar salario');
    }
  }

  Future<void> deleteSalario(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar salario');
    }
  }
}
