// lib/models/empleado_model.dart
class Empleado {
  final int? id;
  final String nombre;
  final String username;
  final String rol;
  final String? cedula;
  final String? correo;
  final String? cargo;
  final String? fechaIngreso;
  final double? salario;
  final int? usuarioId;

  Empleado({
    this.id,
    required this.nombre,
    required this.username, // 👈 requerido
    required this.rol,
    this.cedula,
    this.correo,
    this.cargo,
    this.fechaIngreso,
    this.salario,
    this.usuarioId,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nombre: json['nombre'] ?? '',
      username: json['username'] ?? '',
      rol: json['rol'] ?? '',
      cedula: json['cedula'],
      correo: json['correo'],
      cargo: json['cargo'],
      fechaIngreso: json['fecha_ingreso'],
      salario: json['salario'] != null
          ? double.tryParse(json['salario'].toString())
          : null,
      usuarioId: json['usuario_id'] != null 
          ? int.tryParse(json['usuario_id'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "nombre": nombre,
      "username": username,
      "rol": rol,
      if (cedula != null) "cedula": cedula,
      if (correo != null) "correo": correo,
      if (cargo != null) "cargo": cargo,
      if (fechaIngreso != null) "fecha_ingreso": fechaIngreso,
      if (salario != null) "salario": salario,
      if (usuarioId != null) "usuario_id": usuarioId,
    };
  }

  // Método para crear una copia con cambios
  Empleado copyWith({
    int? id,
    String? nombre,
    String? username,
    String? rol,
    String? cedula,
    String? correo,
    String? cargo,
    String? fechaIngreso,
    double? salario,
    int? usuarioId,
  }) {
    return Empleado(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      username: username ?? this.username, // 👈 incluido en copyWith
      rol: rol ?? this.rol,
      cedula: cedula ?? this.cedula,
      correo: correo ?? this.correo,
      cargo: cargo ?? this.cargo,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      salario: salario ?? this.salario,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  // Getters adicionales para compatibilidad
  String get email => correo ?? '';
  
  @override
  String toString() {
    return 'Empleado{id: $id, nombre: $nombre, username: $username, rol: $rol, cedula: $cedula, correo: $correo, cargo: $cargo, fechaIngreso: $fechaIngreso, salario: $salario, usuarioId: $usuarioId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Empleado &&
        other.id == id &&
        other.nombre == nombre &&
        other.username == username &&
        other.rol == rol &&
        other.cedula == cedula &&
        other.correo == correo &&
        other.cargo == cargo &&
        other.fechaIngreso == fechaIngreso &&
        other.salario == salario &&
        other.usuarioId == usuarioId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      nombre,
      username,
      rol,
      cedula,
      correo,
      cargo,
      fechaIngreso,
      salario,
      usuarioId,
    );
  }
}
