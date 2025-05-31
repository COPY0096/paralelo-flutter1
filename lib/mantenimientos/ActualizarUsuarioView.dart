import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActualizarUsuarioView extends StatefulWidget {
  final int id;
  final String username;
  final String password;

  const ActualizarUsuarioView({
    super.key,
    required this.id,
    required this.username,
    required this.password,
  });

  @override
  State<ActualizarUsuarioView> createState() => _ActualizarUsuarioViewState();
}

class _ActualizarUsuarioViewState extends State<ActualizarUsuarioView> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  Future<void> actualizarUsuario() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/api/usuarios/${widget.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print('Error al actualizar usuario');
    }
  }

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    passwordController = TextEditingController(text: widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Usuario')),
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
              onPressed: actualizarUsuario,
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
