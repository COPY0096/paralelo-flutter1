//import 'package:equatable/equatable.dart';

class UserModel {
  final int id;
  final String username;
  final String nombre;
  final String correo;
  final String rol; 

  UserModel({
    required this.id,
    required this.username,
    required this.nombre,
    required this.correo,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      nombre: json['nombre'] as String? ?? json['username'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      rol: json['rol'] as String? ?? 'invitado',
    );
  }
}





// class UserModel {
//   final int id;
//   final String username;

//   UserModel({required this.id, required this.username});

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       username: json['username'],
//     );
//   }
// }
