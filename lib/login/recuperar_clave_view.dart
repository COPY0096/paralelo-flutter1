import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecuperarClaveView extends StatefulWidget {
  @override
  _RecuperarClaveViewState createState() => _RecuperarClaveViewState();
}

class _RecuperarClaveViewState extends State<RecuperarClaveView> {
  final _usernameController = TextEditingController();
  final _nuevaClaveController = TextEditingController();
  final _confirmarClaveController = TextEditingController();

  Future<void> recuperarClave() async {
    final username = _usernameController.text;
    final nuevaClave = _nuevaClaveController.text;
    final confirmarClave = _confirmarClaveController.text;

    if (nuevaClave != confirmarClave) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2:3000/api/usuarios/recuperar-clave');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'nuevaClave': nuevaClave}),
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['mensaje'])),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['mensaje'] ?? 'Error desconocido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Usuario')),
            TextField(controller: _nuevaClaveController, decoration: InputDecoration(labelText: 'Nueva clave'), obscureText: true),
            TextField(controller: _confirmarClaveController, decoration: InputDecoration(labelText: 'Confirmar nueva clave'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: recuperarClave, child: Text('Actualizar clave')),
          ],
        ),
      ),
    );
  }
}
