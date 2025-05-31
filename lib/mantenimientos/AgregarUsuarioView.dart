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
  final TextEditingController passwordController = TextEditingController();

  Future<void> agregarUsuario() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print('Error al agregar usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: agregarUsuario,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
