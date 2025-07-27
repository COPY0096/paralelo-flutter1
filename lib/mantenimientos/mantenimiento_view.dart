import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'mantenimiento_productos_view.dart';
import 'mantenimiento_usuarios_view.dart';

class MantenimientoView extends StatelessWidget {
  const MantenimientoView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.maintenanceTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(localizations.maintenanceProducts),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MantenimientoProductoView(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(localizations.maintenanceUsers),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MantenimientoUsuarioView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
