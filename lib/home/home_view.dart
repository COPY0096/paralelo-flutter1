// lib/home/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/articulos/api_screen.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../auth/auth_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<AuthViewModel>(
      builder: (context, auth, child) {
        if (!auth.isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          });
        }

        final isAdmin = auth.user?.rol == 'admin';
        final nombreUsuario = auth.user?.nombre ?? auth.user?.username ?? '';

        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.home),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: localizations.logout,
                onPressed: () => auth.logout(),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${localizations.home}, $nombreUsuario!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  _buildButton(
                    context,
                    icon: Icons.person,
                    label: localizations.profileTitle,
                    route: '/perfil',
                  ),
                  _buildButton(
                    context,
                    icon: Icons.inventory,
                    label: localizations.products,
                    route: '/productos',
                  ),
                  _buildButton(
                    context,
                    icon: Icons.build,
                    label: localizations.users,
                    route: '/mantenimientos',
                  ),
                  _buildButton(
                    context,
                    icon: Icons.image,
                    label: 'Imágenes',
                    route: '/imagenes',
                  ),
                  _buildCustomButton(
                    context,
                    icon: Icons.api,
                    label: 'API',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ApiScreen()),
                    ),
                  ),
                  if (isAdmin)
                    _buildButton(
                      context,
                      icon: Icons.business_center,
                      label: 'Recursos Humanos',
                      route: '/recursos-humanos',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context,
      {required IconData icon, required String label, required String route}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}


