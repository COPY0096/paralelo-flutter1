// lib/mantenimientos/recursos_humanos/agregar_empleado_view.dart
import 'package:flutter/material.dart';

class AgregarEmpleadoView extends StatelessWidget {
  const AgregarEmpleadoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Empleado')),
      body: const Center(child: Text('Formulario para agregar empleado aquí')),
    );
  }
}
