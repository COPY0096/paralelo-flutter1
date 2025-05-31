import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

import 'AgregarUsuarioView.dart';
import 'ActualizarUsuarioView.dart';

class MantenimientoUsuarioView extends StatefulWidget {
  const MantenimientoUsuarioView({super.key});

  @override
  State<MantenimientoUsuarioView> createState() => _MantenimientoUsuarioViewState();
}

class _MantenimientoUsuarioViewState extends State<MantenimientoUsuarioView> {
  List usuarios = [];

  Future<void> fetchUsuarios() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/usuarios'));
    if (response.statusCode == 200) {
      setState(() {
        usuarios = jsonDecode(response.body);
      });
    } else {
      log('Error al cargar usuarios');
      print('Error al cargar usuarios');
    }
  }

  Future<void> eliminarUsuario(int id) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:3000/api/usuarios/$id'));
    if (response.statusCode == 200) {
      fetchUsuarios();
    } else {
      log('Error al eliminar usuario');
      print('Error al eliminar usuario');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimiento de Usuarios')),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario['username']),
            subtitle: Text('ID: ${usuario['id']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActualizarUsuarioView(
                          id: usuario['id'],
                          username: usuario['username'],
                          password: usuario['password'],
                        ),
                      ),
                    ).then((_) => fetchUsuarios());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => eliminarUsuario(usuario['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarUsuarioView()),
          ).then((_) => fetchUsuarios());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
