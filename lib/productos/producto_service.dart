import 'dart:convert';
import 'package:http/http.dart' as http;
import 'producto.dart';

class ProductoService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Producto>> fetchProductos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/productos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Producto.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }
}
