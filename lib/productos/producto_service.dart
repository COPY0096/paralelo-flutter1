//lib/productos/producto_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'producto.dart';

class ProductoService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/productos';

  // Obtener todos los productos
  Future<List<Producto>> fetchProductos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print('📥 GET Productos - STATUS: ${response.statusCode}');
      print('📥 GET Productos - BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Producto.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al obtener productos: $e');
      throw Exception('Error de conexión al cargar productos');
    }
  }

  // Vender producto (actualizar stock)
  Future<Map<String, dynamic>> venderProducto(int id, int cantidad) async {
    try {
      print('📤 Vendiendo producto ID: $id, Cantidad: $cantidad');
      
      final response = await http.post(
        Uri.parse('$baseUrl/$id/vender'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cantidad': cantidad}),
      );

      print('📥 Venta - STATUS: ${response.statusCode}');
      print('📥 Venta - BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        // Intentar obtener el mensaje de error del servidor
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['error'] ?? 'Error desconocido';
          throw Exception(errorMessage);
        } catch (_) {
          throw Exception('Error al vender producto: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('⚠️ Error al vender producto: $e');
      rethrow; // Re-lanzar para que el UI pueda manejar el error específico
    }
  }

  // Reabastecer producto (aumentar stock)
  Future<Map<String, dynamic>> reabastecerProducto(int id, int cantidad) async {
    try {
      print('📤 Reabasteciendo producto ID: $id, Cantidad: $cantidad');
      
      final response = await http.post(
        Uri.parse('$baseUrl/$id/reabastecer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cantidad': cantidad}),
      );

      print('📥 Reabastecimiento - STATUS: ${response.statusCode}');
      print('📥 Reabastecimiento - BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        // Intentar obtener el mensaje de error del servidor
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['error'] ?? 'Error desconocido';
          throw Exception(errorMessage);
        } catch (_) {
          throw Exception('Error al reabastecer producto: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('⚠️ Error al reabastecer producto: $e');
      rethrow; // Re-lanzar para que el UI pueda manejar el error específico
    }
  }

  // Obtener producto por ID
  Future<Producto> fetchProductoById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      print('📥 GET Producto $id - STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Producto.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Producto no encontrado');
      } else {
        throw Exception('Error al cargar producto: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al obtener producto $id: $e');
      rethrow;
    }
  }

  // Crear producto
  Future<Map<String, dynamic>> createProducto(Map<String, dynamic> productoData) async {
    try {
      print('📤 Creando producto: ${jsonEncode(productoData)}');
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productoData),
      );

      print('📥 Crear Producto - STATUS: ${response.statusCode}');
      print('📥 Crear Producto - BODY: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Error al crear producto: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al crear producto: $e');
      rethrow;
    }
  }

  // Actualizar producto
  Future<Map<String, dynamic>> updateProducto(int id, Map<String, dynamic> productoData) async {
    try {
      print('📤 Actualizando producto $id: ${jsonEncode(productoData)}');
      
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productoData),
      );

      print('📥 Actualizar Producto - STATUS: ${response.statusCode}');
      print('📥 Actualizar Producto - BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Error al actualizar producto: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al actualizar producto: $e');
      rethrow;
    }
  }

  // Eliminar producto
  Future<void> deleteProducto(int id) async {
    try {
      print('📤 Eliminando producto ID: $id');
      
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      print('📥 Eliminar Producto - STATUS: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar producto: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al eliminar producto: $e');
      rethrow;
    }
  }

  // Obtener historial de ventas
  Future<List<Map<String, dynamic>>> historialVentas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/historial/ventas'));

      print('📥 GET Historial Ventas - STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al cargar historial de ventas: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al obtener historial de ventas: $e');
      rethrow;
    }
  }

  // Obtener historial de reabastecimientos
  Future<List<Map<String, dynamic>>> historialReabastecimientos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/historial/reabastecimientos'));

      print('📥 GET Historial Reabastecimientos - STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al cargar historial de reabastecimientos: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al obtener historial de reabastecimientos: $e');
      rethrow;
    }
  }

  // Obtener movimientos de un producto específico
  Future<Map<String, dynamic>> movimientosProducto(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id/movimientos'));

      print('📥 GET Movimientos Producto $id - STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Error al cargar movimientos del producto: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error al obtener movimientos del producto: $e');
      rethrow;
    }
  }

  // Verificar conexión con el servidor
  Future<bool> verificarConexion() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('⚠️ Error de conexión: $e');
      return false;
    }
  }
}
