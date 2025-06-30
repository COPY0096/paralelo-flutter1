import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_view_model.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final user = auth.user!; // asumimos que está logueado

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario: ${user.username}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Nombre: ${user.nombre}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Correo: ${user.correo}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Rol: ${user.rol}', style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Editar perfil'),
              onPressed: () {
                // Aquí puedes navegar a una vista de edición de perfil
              },
            ),
          ],
        ),
      ),
    );
  }
}
