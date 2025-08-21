//lib/mantenimientos/recursos_humanos/acciones_personal_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AccionesPersonalService {
  static const String base = 'http://10.0.2.2:3000/api';

  // Vacaciones
  static Future<void> crearVacacion({
    required int empleadoId,
    required String fechaInicio, // YYYY-MM-DD
    required String fechaFin,    // YYYY-MM-DD
    String? motivo,
    String estado = 'aprobada',
  }) async {
    final url = Uri.parse('$base/vacaciones');
    final body = {
      'empleado_id': empleadoId,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'motivo': motivo,
      'estado': estado,
    };

    final res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (res.statusCode != 201) {
      throw Exception('Error al crear vacación: ${res.statusCode} -> ${res.body}');
    }
  }

  // Pagos de salario
  static Future<void> crearPagoSalario({
    required int empleadoId,
    required double monto,
    String? periodoInicio, // YYYY-MM-DD
    String? periodoFin,    // YYYY-MM-DD
    String? fechaPago,     // YYYY-MM-DD (opcional)
    String metodo = 'transferencia',
    String? comentarios,
  }) async {
    final url = Uri.parse('$base/pagos-salarios');
    final body = {
      'empleado_id': empleadoId,
      'monto': monto,
      'periodo_inicio': periodoInicio,
      'periodo_fin': periodoFin,
      'fecha_pago': fechaPago,
      'metodo': metodo,
      'comentarios': comentarios,
    };

    final res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (res.statusCode != 201) {
      throw Exception('Error al crear pago de salario: ${res.statusCode} -> ${res.body}');
    }
  }
}
