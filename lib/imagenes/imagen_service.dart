import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImagenService {
  final String baseUrl = 'http://10.0.2.2:3000'; // tu backend

  Future<List<String>> obtenerImagenes() async {
    final response = await http.get(Uri.parse('$baseUrl/imagenes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((img) => img['ruta'] as String).toList();
    } else {
      throw Exception('Error al obtener imágenes');
    }
  }

  // Nuevo método para subir imagen
  Future<Map<String, dynamic>> subirImagen(File archivo) async {
    final uri = Uri.parse('$baseUrl/api/imagenes/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('imagen', archivo.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al subir imagen');
    }
  }
}