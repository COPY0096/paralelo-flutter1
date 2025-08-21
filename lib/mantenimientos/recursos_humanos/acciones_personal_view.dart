// lib/mantenimientos/recursos_humanos/acciones_personal_view.dart
import 'package:flutter/material.dart';

class AccionesPersonalView extends StatelessWidget {
  const AccionesPersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acciones de Personal')),
      body: const Center(child: Text('Vacaciones, salarios, permisos, despido aquí')),
    );
  }
}
