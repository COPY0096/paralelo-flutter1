// lib/mantenimientos/recursos_humanos/permiso_model.dart

class Permiso {
  final int? id;
  final int usuarioId;
  final String tipo;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Permiso({
    this.id,
    required this.usuarioId,
    required this.tipo,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Permiso.fromJson(Map<String, dynamic> json) => Permiso(
        id: json['id'],
        usuarioId: json['usuario_id'],
        tipo: json['tipo'],
        fechaInicio: DateTime.parse(json['fecha_inicio']),
        fechaFin: DateTime.parse(json['fecha_fin']),
      );

  Map<String, dynamic> toJson() => {
        'usuario_id': usuarioId,
        'tipo': tipo,
        'fecha_inicio': fechaInicio.toIso8601String(),
        'fecha_fin': fechaFin.toIso8601String(),
      };
}
