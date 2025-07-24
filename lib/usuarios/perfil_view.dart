import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_view_model.dart';
import '../theme/theme_view_model.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final themeVM = Provider.of<ThemeViewModel>(context);
    final currentTheme = themeVM.themeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario: ${auth.user?.nombre ?? auth.user?.username ?? ''}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Correo: ${auth.user?.correo ?? ''}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Rol: ${auth.user?.rol ?? ''}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            const Text('Tema de la aplicación', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<ThemePreference>(
              title: const Text('Según el sistema'),
              value: ThemePreference.system,
              groupValue: _mapThemeModeToPreference(currentTheme),
              onChanged: (value) {
                if (value != null) themeVM.setTheme(value);
              },
            ),
            RadioListTile<ThemePreference>(
              title: const Text('Modo claro'),
              value: ThemePreference.light,
              groupValue: _mapThemeModeToPreference(currentTheme),
              onChanged: (value) {
                if (value != null) themeVM.setTheme(value);
              },
            ),
            RadioListTile<ThemePreference>(
              title: const Text('Modo oscuro'),
              value: ThemePreference.dark,
              groupValue: _mapThemeModeToPreference(currentTheme),
              onChanged: (value) {
                if (value != null) themeVM.setTheme(value);
              },
            ),
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

  ThemePreference _mapThemeModeToPreference(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return ThemePreference.light;
      case ThemeMode.dark:
        return ThemePreference.dark;
      case ThemeMode.system:
      default:
        return ThemePreference.system;
    }
  }
}
