import 'dart:convert';
import 'package:http/http.dart' as http;
import 'producto.dart';

class ProductoService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/productos';

  Future<List<Producto>> fetchProductos() async {
    final response = await http.get(Uri.parse(baseUrl));

    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Producto.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}
