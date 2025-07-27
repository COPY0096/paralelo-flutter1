// lib/usuarios/perfil_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../auth/auth_view_model.dart';
import '../theme/theme_view_model.dart';
import '../locale/locale_provider.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final themeVM = Provider.of<ThemeViewModel>(context);
    final currentTheme = themeVM.themeMode;
    final localizations = AppLocalizations.of(context)!;

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
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    auth.user?.nombre ?? auth.user?.username ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    auth.user?.correo ?? '',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(localizations.username, auth.user?.username ?? ''),
            _buildInfoCard(localizations.email, auth.user?.correo ?? ''),
            _buildInfoCard(localizations.role, auth.user?.rol ?? ''),

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
                // Aquí puedes navegar a una vista de edición de perfil
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
