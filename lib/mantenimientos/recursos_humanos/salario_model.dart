// lib/mantenimientos/recursos_humanos/salario_model.dart

class Salario {
  final int? id;
  final int usuarioId;
  final double salario;
  final DateTime fechaAsignacion;

  Salario({
    this.id,
    required this.usuarioId,
    required this.salario,
    required this.fechaAsignacion,
  });

  factory Salario.fromJson(Map<String, dynamic> json) {
    return Salario(
      id: json['id'],
      usuarioId: json['usuario_id'],
      salario: (json['salario'] as num).toDouble(), // <- Cambiado de monto a salario
      fechaAsignacion: DateTime.parse(json['fecha_asignacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'salario': salario, // <- Asegurarse de usar 'salario'
      'fecha_asignacion': fechaAsignacion.toIso8601String(),
    };
  }
}
