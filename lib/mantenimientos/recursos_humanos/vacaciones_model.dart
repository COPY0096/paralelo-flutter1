// lib/mantenimientos/recursos_humanos/vacaciones_model.dart

class Vacaciones {
  final int? id;
  final int usuarioId;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Vacaciones({
    this.id,
    required this.usuarioId,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Vacaciones.fromJson(Map<String, dynamic> json) => Vacaciones(
        id: json['id'],
        usuarioId: json['usuario_id'],
        fechaInicio: DateTime.parse(json['fecha_inicio']),
        fechaFin: DateTime.parse(json['fecha_fin']),
      );

  Map<String, dynamic> toJson() => {
        'usuario_id': usuarioId,
        'fecha_inicio': fechaInicio.toIso8601String(),
        'fecha_fin': fechaFin.toIso8601String(),
      };
}
