// lib/home/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
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
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "SmartControl Dashboard",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: localizations.logout,
                onPressed: () => auth.logout(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  "${localizations.home}, $nombreUsuario 👋",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Explora tus módulos y gestiona todo en un solo lugar",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 24),

                // Dashboard
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: [
                      _buildDashboardCard(
                        context,
                        icon: Icons.person,
                        label: localizations.profileTitle,
                        color: Colors.blue,
                        route: '/perfil',
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.inventory,
                        label: localizations.products,
                        color: Colors.green,
                        route: '/productos',
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.group,
                        label: "Mantenimientos",
                        color: Colors.orange,
                        route: '/mantenimientos',
                      ),
                      if (isAdmin)
                        _buildDashboardCard(
                          context,
                          icon: Icons.business_center,
                          label: "Recursos Humanos",
                          color: Colors.purple,
                          route: '/recursos-humanos',
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required String route,
      required Color color}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 52, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


