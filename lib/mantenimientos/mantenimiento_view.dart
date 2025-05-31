import 'package:flutter/material.dart';
import 'mantenimiento_productos_view.dart';
import 'mantenimiento_usuarios_view.dart';

class MantenimientoView extends StatelessWidget {
  const MantenimientoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimientos')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Mantenimiento de Productos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MantenimientoProductoView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mantenimiento de Usuarios'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MantenimientoUsuarioView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
