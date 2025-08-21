// lib/mantenimientos/recursos_humanos/vacaciones_model.dart
class Vacacion {
  final int id;
  final int empleadoId;
  final String fechaInicio;
  final String fechaFin;
  final int dias;
  final String? motivo;
  final String estado;
  final String? empleado;

  Vacacion({
    required this.id,
    required this.empleadoId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.dias,
    required this.estado,
    this.motivo,
    this.empleado,
  });

  factory Vacacion.fromJson(Map<String, dynamic> json) => Vacacion(
    id: json['id'],
    empleadoId: json['empleado_id'],
    fechaInicio: json['fecha_inicio'],
    fechaFin: json['fecha_fin'],
    dias: json['dias'],
    estado: json['estado'],
    motivo: json['motivo'],
    empleado: json['empleado'],
  );
}
