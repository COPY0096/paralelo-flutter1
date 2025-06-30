import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgregarUsuarioView extends StatefulWidget {
  const AgregarUsuarioView({super.key});

  @override
  State<AgregarUsuarioView> createState() => _AgregarUsuarioViewState();
}

class _AgregarUsuarioViewState extends State<AgregarUsuarioView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nombreController   = TextEditingController();
  final TextEditingController correoController   = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String rol = 'invitado';
  final List<String> roles = ['admin', 'operador', 'invitado'];

  Future<void> agregarUsuario() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/usuarios'),
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
        const SnackBar(content: Text('Error al agregar usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Usuario')),
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
            onPressed: agregarUsuario,
            child: const Text('Guardar'),
          ),
        ]),
      ),
    );
  }
}


//v2
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AgregarUsuarioView extends StatefulWidget {
//   const AgregarUsuarioView({super.key});

//   @override
//   State<AgregarUsuarioView> createState() => _AgregarUsuarioViewState();
// }

// class _AgregarUsuarioViewState extends State<AgregarUsuarioView> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController correoController   = TextEditingController();
//   String rol = 'invitado';
//   final List<String> roles = ['admin', 'operador', 'invitado'];

//   Future<void> agregarUsuario() async {
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/usuarios'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'username': usernameController.text,
//         'password': passwordController.text,
//         'correo':   correoController.text,
//         'rol':      rol,
//       }),
//     );

//     if (response.statusCode == 200) {
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Error al agregar usuario')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Agregar Usuario')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(children: [
//           TextField(
//             controller: usernameController,
//             decoration: const InputDecoration(labelText: 'Username'),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: correoController,
//             decoration: const InputDecoration(labelText: 'Correo'),
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: passwordController,
//             decoration: const InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           const SizedBox(height: 12),
//           DropdownButtonFormField<String>(
//             value: rol,
//             decoration: const InputDecoration(labelText: 'Rol'),
//             items: roles
//                 .map((r) => DropdownMenuItem(value: r, child: Text(r)))
//                 .toList(),
//             onChanged: (v) {
//               if (v != null) setState(() => rol = v);
//             },
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: agregarUsuario,
//             child: const Text('Guardar'),
//           ),
//         ]),
//       ),
//     );
//   }
// }


//original code for reference, not needed in the final implementation
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AgregarUsuarioView extends StatefulWidget {
//   const AgregarUsuarioView({super.key});

//   @override
//   State<AgregarUsuarioView> createState() => _AgregarUsuarioViewState();
// }

// class _AgregarUsuarioViewState extends State<AgregarUsuarioView> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> agregarUsuario() async {
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/usuarios'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'username': usernameController.text,
//         'password': passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       Navigator.pop(context);
//     } else {
//       print('Error al agregar usuario');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Agregar Usuario')),
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
//               onPressed: agregarUsuario,
//               child: const Text('Guardar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
