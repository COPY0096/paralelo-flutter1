import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../productos/productos_view.dart';
import '../auth/auth_view_model.dart'; // Asegúrate de que la ruta sea correcta
// Importa aquí las vistas correspondientes cuando las tengas:
// import '../views/mantenimientos_view.dart';
// import '../views/imagenes_view.dart';
// import '../views/api_rest_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductosView()),
        );
      },
      child: const Text('Productos'),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductosView()),
        );
      },
      child: const Text('Ver productos'),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
      onPressed: () {
        // TODO: Navegar a la vista de Mantenimientos
      },
      child: const Text('Mantenimientos'),
    ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navegar a la vista de Cargar/Buscar Imágenes
              },
              child: const Text('Cargar/Buscar Imágenes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navegar a la vista de API REST con Node
              },
              child: const Text('API REST con Node'),
            ),
                       ElevatedButton(
              onPressed: () {
                Provider.of<AuthViewModel>(context, listen: false).logout();
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}