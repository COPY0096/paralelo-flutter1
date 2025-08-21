// lib/mantenimientos/recursos_humanos/salario_model.dart

class PagoSalario {
  final int id;
  final int empleadoId;
  final double monto;
  final String? periodoInicio;
  final String? periodoFin;
  final String fechaPago;
  final String metodo;
  final String? comentarios;
  final String? empleado;

  PagoSalario({
    required this.id,
    required this.empleadoId,
    required this.monto,
    required this.fechaPago,
    required this.metodo,
    this.periodoInicio,
    this.periodoFin,
    this.comentarios,
    this.empleado,
  });

  factory PagoSalario.fromJson(Map<String, dynamic> json) => PagoSalario(
    id: json['id'],
    empleadoId: json['empleado_id'],
    monto: double.tryParse(json['monto'].toString()) ?? 0,
    fechaPago: json['fecha_pago'],
    metodo: json['metodo'] ?? 'transferencia',
    periodoInicio: json['periodo_inicio'],
    periodoFin: json['periodo_fin'],
    comentarios: json['comentarios'],
    empleado: json['empleado'],
  );
}
