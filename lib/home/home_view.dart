import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/articulos/api_screen.dart';
import 'package:provider/provider.dart';
import '../auth/auth_view_model.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, auth, child) {
        if (!auth.isLoggedIn) {
          // Navegar a login y limpiar pila
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          });
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Menú Principal')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bienvenido, ${auth.username}!',
                  style: const TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/productos'),
                  child: const Text('Ver productos'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/mantenimientos'),
                  child: const Text('Mantenimientos'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/imagenes'),
                  child: const Text('Imágenes'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ApiScreen()),
                    );
                  },
                  child: Text('API'),
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
      },
    );
  }
}