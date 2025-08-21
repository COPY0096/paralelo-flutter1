// lib/services/empleado_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/empleado_model.dart';

class EmpleadoService {
  static const String baseUrl = "http://10.0.2.2:3000/api/empleados";

  // Obtener todos los empleados
  static Future<List<Empleado>> getEmpleados() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((e) => Empleado.fromJson(e)).toList();
      } else {
        print("⚠️ Error al cargar empleados: ${response.statusCode} -> ${response.body}");
        throw Exception("Error al cargar empleados: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Excepción al cargar empleados: $e");
      throw Exception("Error de conexión al cargar empleados");
    }
  }

  // Agregar empleado con estructura simplificada
  static Future<void> agregarEmpleadoSimple(Map<String, dynamic> empleadoData) async {
    try {
      // Preparar estructura para el backend simplificado
      final empleado = {
        "nombre": empleadoData["nombre"],
        "cedula": empleadoData["cedula"],
        "cargo": empleadoData["cargo"],
        "salario": empleadoData["salario"] ?? 0.0,
        "correo": empleadoData["correo"],
        "password": empleadoData["password"],
        "rol": empleadoData["rol"], // admin, operador, invitado
      };

      print("📤 Enviando empleado: ${json.encode(empleado)}");
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(empleado),
      );

      print("📥 Respuesta del servidor: ${response.statusCode} -> ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        print("⚠️ Error al agregar empleado: ${response.statusCode} -> ${response.body}");
        
        // Intentar parsear el error del servidor
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['error'] ?? errorData['mensaje'] ?? 'Error desconocido';
          throw Exception(errorMessage);
        } catch (_) {
          throw Exception("Error al agregar empleado: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("⚠️ Excepción al agregar empleado: $e");
      throw Exception("Error de conexión: $e");
    }
  }

  // Agregar empleado con usuario opcional (estructura anidada)
  static Future<void> agregarEmpleadoConUsuario(Map<String, dynamic> empleadoData) async {
    try {
      print("📤 Enviando empleado con usuario: ${json.encode(empleadoData)}");
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(empleadoData),
      );

      print("📥 Respuesta del servidor: ${response.statusCode} -> ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        print("⚠️ Error al agregar empleado: ${response.statusCode} -> ${response.body}");
        throw Exception("Error al agregar empleado: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Excepción al agregar empleado: $e");
      throw Exception("Error de conexión al agregar empleado");
    }
  }

  // Agregar empleado (método original)
  static Future<void> agregarEmpleado(Empleado empleado) async {
    try {
      print("📤 Enviando empleado: ${json.encode(empleado.toJson())}");
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(empleado.toJson()),
      );

      print("📥 Respuesta del servidor: ${response.statusCode} -> ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        print("⚠️ Error al agregar empleado: ${response.statusCode} -> ${response.body}");
        throw Exception("Error al agregar empleado: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Excepción al agregar empleado: $e");
      throw Exception("Error de conexión al agregar empleado");
    }
  }

  // Eliminar empleado
  static Future<void> deleteEmpleado(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      
      if (response.statusCode != 200) {
        print("⚠️ Error al eliminar empleado: ${response.statusCode} -> ${response.body}");
        throw Exception("Error al eliminar empleado: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Excepción al eliminar empleado: $e");
      throw Exception("Error de conexión al eliminar empleado");
    }
  }

  // Actualizar empleado
  static Future<void> updateEmpleado(Empleado empleado) async {
    try {
      print("📤 Actualizando empleado: ${json.encode(empleado.toJson())}");
      
      final response = await http.put(
        Uri.parse("$baseUrl/${empleado.id}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(empleado.toJson()),
      );

      print("📥 Respuesta del servidor: ${response.statusCode} -> ${response.body}");

      if (response.statusCode != 200) {
        print("⚠️ Error al actualizar empleado: ${response.statusCode} -> ${response.body}");
        throw Exception("Error al actualizar empleado: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Excepción al actualizar empleado: $e");
      throw Exception("Error de conexión al actualizar empleado");
    }
  }

  // Actualizar empleado con datos estructurados
  static Future<void> actualizarEmpleadoConDatos(int id, Map<String, dynamic> empleadoData) async {
    try {
      print("📤 Actualizando empleado ID $id: ${json.encode(empleadoData)}");
      
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(empleadoData),
      );

      print("📥 Respuesta del servidor: ${response.statusCode} -> ${response.body}");

      if (response.statusCode != 200) {
        print("⚠️ Error al actualizar empleado: ${response.statusCode} -> ${response.body}");
        throw Exception("Error al actualizar empleado: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Excepción al actualizar empleado: $e");
      throw Exception("Error de conexión al actualizar empleado");
    }
  }

  // Método auxiliar para verificar conexión
  static Future<bool> verificarConexion() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("⚠️ Error de conexión: $e");
      return false;
    }
  }
}
