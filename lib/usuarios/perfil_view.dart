// lib/usuarios/perfil_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../auth/auth_view_model.dart';
import '../theme/theme_view_model.dart';
import '../locale/locale_provider.dart';
import 'cambiar_clave_view.dart';
import 'editar_perfil_view.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final themeVM = Provider.of<ThemeViewModel>(context);
    final currentTheme = themeVM.themeMode;
    final localizations = AppLocalizations.of(context)!;

    // Obtener datos del usuario actual
    final userName = auth.user?.nombre ?? 'Sin nombre';
    final userUsername = auth.user?.username ?? 'Sin usuario';
    final userEmail = auth.user?.correo ?? 'Sin correo';
    final userRole = auth.user?.rol ?? 'Sin rol';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profileTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          _getInitials(userName, userUsername),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getRoleColor(userRole),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            _getRoleIcon(userRole),
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@$userUsername',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          userEmail,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRoleColor(userRole).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getRoleColor(userRole).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getRoleIcon(userRole),
                          size: 16,
                          color: _getRoleColor(userRole),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getRoleDisplayName(userRole),
                          style: TextStyle(
                            color: _getRoleColor(userRole),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Información detallada del usuario
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información Personal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailedInfoRow(
                      icon: Icons.person_outline,
                      label: localizations.username,
                      value: userUsername,
                      context: context,
                    ),
                    const Divider(height: 24),
                    _buildDetailedInfoRow(
                      icon: Icons.badge_outlined,
                      label: 'Nombre completo',
                      value: userName,
                      context: context,
                    ),
                    const Divider(height: 24),
                    _buildDetailedInfoRow(
                      icon: Icons.email_outlined,
                      label: localizations.email,
                      value: userEmail,
                      context: context,
                    ),
                    const Divider(height: 24),
                    _buildDetailedInfoRow(
                      icon: _getRoleIcon(userRole),
                      label: localizations.role,
                      value: _getRoleDisplayName(userRole),
                      context: context,
                      valueColor: _getRoleColor(userRole),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(localizations.appTheme, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildThemeOption(localizations.systemTheme, ThemePreference.system, currentTheme, themeVM),
            _buildThemeOption(localizations.lightMode, ThemePreference.light, currentTheme, themeVM),
            _buildThemeOption(localizations.darkMode, ThemePreference.dark, currentTheme, themeVM),

            const SizedBox(height: 24),
            Text(localizations.appLanguage, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                final selectedLang = localeProvider.locale?.languageCode ?? 'system';

                return DropdownButton<String>(
                  value: selectedLang,
                  isExpanded: true,
                  onChanged: (String? newLangCode) {
                    if (newLangCode == 'system') {
                      localeProvider.clearLocale();
                    } else {
                      localeProvider.setLocale(Locale(newLangCode!));
                    }
                  },
                  items: [
                    DropdownMenuItem(value: 'system', child: Text(localizations.systemDefault)),
                    DropdownMenuItem(value: 'es', child: const Text('Español')),
                    DropdownMenuItem(value: 'en', child: const Text('English')),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: Text(localizations.editProfile),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Opciones de Perfil',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.lock, color: Colors.orange),
                          title: const Text('Cambiar clave'),
                          subtitle: const Text('Actualizar tu contraseña de acceso'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (_) => const CambiarClaveView()
                              )
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.edit, color: Colors.blue),
                          title: const Text('Actualizar datos'),
                          subtitle: const Text('Modificar información personal'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (_) => const EditarPerfilView()
                              )
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos helper
  String _getInitials(String nombre, String username) {
    if (nombre.isNotEmpty && nombre != 'Sin nombre') {
      final parts = nombre.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return nombre[0].toUpperCase();
    }
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'usuario':
        return Colors.blue;
      case 'moderador':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'usuario':
        return Icons.person;
      case 'moderador':
        return Icons.verified_user;
      default:
        return Icons.help_outline;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrador';
      case 'usuario':
        return 'Usuario';
      case 'moderador':
        return 'Moderador';
      default:
        return role;
    }
  }

  Widget _buildDetailedInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildThemeOption(
    String label,
    ThemePreference value,
    ThemeMode currentTheme,
    ThemeViewModel themeVM,
  ) {
    return RadioListTile<ThemePreference>(
      title: Text(label),
      value: value,
      groupValue: _mapThemeModeToPreference(currentTheme),
      onChanged: (newValue) {
        if (newValue != null) {
          themeVM.setTheme(newValue);
        }
      },
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
