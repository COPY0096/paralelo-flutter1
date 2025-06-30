import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActualizarUsuarioView extends StatefulWidget {
  final int id;
  final String username;
  final String nombre;
  final String correo;
  final String rol;
  final String password;

  const ActualizarUsuarioView({
    super.key,
    required this.id,
    required this.username,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.password,
  });

  @override
  State<ActualizarUsuarioView> createState() => _ActualizarUsuarioViewState();
}

class _ActualizarUsuarioViewState extends State<ActualizarUsuarioView> {
  late TextEditingController usernameController;
  late TextEditingController nombreController;
  late TextEditingController correoController;
  late TextEditingController passwordController;
  late String rol;

  final List<String> roles = ['admin', 'operador', 'invitado'];

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    nombreController   = TextEditingController(text: widget.nombre);
    correoController   = TextEditingController(text: widget.correo);
    passwordController = TextEditingController(text: widget.password);
    rol = widget.rol;
  }

  Future<void> actualizarUsuario() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/api/usuarios/${widget.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'nombre':   nombreController.text,
        'correo':   correoController.text,
        'password': passwordController.text,
        'rol':      rol,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Usuario'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: correoController,
            decoration: const InputDecoration(labelText: 'Correo'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: rol,
            decoration: const InputDecoration(labelText: 'Rol'),
            items: roles
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => rol = v);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: actualizarUsuario,
            child: const Text('Actualizar'),
          ),
        ]),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ActualizarUsuarioView extends StatefulWidget {
//   final int id;
//   final String username;
//   final String password;

//   const ActualizarUsuarioView({
//     super.key,
//     required this.id,
//     required this.username,
//     required this.password,
//   });

//   @override
//   State<ActualizarUsuarioView> createState() => _ActualizarUsuarioViewState();
// }

// class _ActualizarUsuarioViewState extends State<ActualizarUsuarioView> {
//   late TextEditingController usernameController;
//   late TextEditingController passwordController;

//   Future<void> actualizarUsuario() async {
//     final response = await http.put(
//       Uri.parse('http://10.0.2.2:3000/api/usuarios/${widget.id}'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'username': usernameController.text,
//         'password': passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       Navigator.pop(context);
//     } else {
//       print('Error al actualizar usuario');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     usernameController = TextEditingController(text: widget.username);
//     passwordController = TextEditingController(text: widget.password);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Actualizar Usuario')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: usernameController,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: actualizarUsuario,
//               child: const Text('Actualizar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
