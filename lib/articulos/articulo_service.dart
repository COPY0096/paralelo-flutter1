import 'dart:convert';
import 'package:http/http.dart' as http;
import 'articulo_model.dart';

Future<List<Articulo>> fetchArticulos({String consulta = ''}) async {
  final url = Uri.parse('https://softecard.com/borrar.php?t=Articulo_Lista_Select&consulta=$consulta');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List lista = data['articulos'] ?? [];
    return lista.map((e) => Articulo.fromJson(e)).take(10).toList(); // Mostrar solo 10
  } else {
    throw Exception('Error al cargar artículos');
  }
}
