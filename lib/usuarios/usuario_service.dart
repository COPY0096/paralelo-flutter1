// lib/usuarios/usuario_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UsuarioService {
  final String baseUrl = 'http://10.0.2.2:3000/api'; // Para emulador Android
  // final String baseUrl = 'http://localhost:3000/api'; // Para web/desktop
  
  // Timeout para las peticiones
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<bool> actualizarUsuario(UserModel usuario) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/usuarios/${usuario.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': usuario.username,
          'nombre': usuario.nombre,
          'correo': usuario.correo,
          'rol': usuario.rol,
        }),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 409) {
        // Conflicto - correo o username ya en uso
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['mensaje'] ?? 'El correo o nombre de usuario ya están en uso');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['mensaje'] ?? 'Datos inválidos');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['mensaje'] ?? errorData['error'] ?? 'Error al actualizar usuario');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      }
      rethrow;
    }
  }

  Future<bool> cambiarClave(int userId, String claveActual, String nuevaClave) async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/api/usuarios/$userId/cambiar-clave');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'claveActual': claveActual,
          'nuevaClave': nuevaClave,
        }),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Contraseña actual incorrecta');
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['mensaje'] ?? 'Datos inválidos');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['mensaje'] ?? 'Error al cambiar la contraseña');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      }
      rethrow;
    }
  }

  // Método para cambiar clave directa con ambas contraseñas (ahora requiere clave actual)
  Future<bool> cambiarClaveDirecta(int id, String claveActual, String nuevaClave) async {
    try {
      print('Enviando petición a: http://10.0.2.2:3000/api/usuarios/$id/cambiar-clave');
      print('Datos enviados: {"claveActual": "$claveActual", "nuevaClave": "$nuevaClave"}');

      final url = Uri.parse('http://10.0.2.2:3000/api/usuarios/$id/cambiar-clave');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'claveActual': claveActual,
          'nuevaClave': nuevaClave,
        }),
      ).timeout(timeoutDuration);

      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Respuesta exitosa: $responseData');
        return true;
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['mensaje'] ?? errorData['error'] ?? 'Datos inválidos');
      } else if (response.statusCode == 401) {
        throw Exception('Contraseña actual incorrecta');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['mensaje'] ?? errorData['error'] ?? 'Error al cambiar la contraseña');
      }
    } catch (e) {
      print('Error en cambiarClaveDirecta: $e');
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      }
      if (e.toString().contains('SocketException')) {
        throw Exception('No se puede conectar al servidor. Verifica tu conexión.');
      }
      rethrow;
    }
  }

  Future<UserModel?> obtenerUsuario(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/usuarios/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return UserModel.fromJson(userData['usuario'] ?? userData);
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error al obtener usuario');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      }
      rethrow;
    }
  }

  Future<List<UserModel>> obtenerTodosLosUsuarios() async {
    try {
      final url = Uri.parse('$baseUrl/usuarios');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> usersData = jsonDecode(response.body);
        return usersData.map((json) => UserModel.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error al obtener usuarios');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      }
      rethrow;
    }
  }

  Future<bool> eliminarUsuario(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/usuarios/$userId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error al eliminar usuario');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      }
      rethrow;
    }
  }

  // Método para validar conectividad
  Future<bool> verificarConexion() async {
    try {
      final url = Uri.parse('$baseUrl/health'); // Endpoint de salud si lo tienes
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}