// lib/mantenimientos/recursos_humanos/recursos_humanos_view.dart

import 'package:flutter/material.dart';
import 'salario_view.dart';
import 'permiso_view.dart';
import 'vacaciones_view.dart';

class RecursosHumanosView extends StatelessWidget {
  const RecursosHumanosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recursos Humanos')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalarioView()),
              ),
              icon: const Icon(Icons.attach_money),
              label: const Text('Salarios'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PermisoView()),
              ),
              icon: const Icon(Icons.calendar_month),
              label: const Text('Permisos'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VacacionesView()),
              ),
              icon: const Icon(Icons.beach_access),
              label: const Text('Vacaciones'),
            ),
          ],
        ),
      ),
    );
  }
}
