// lib/mantenimientos/recursos_humanos/recursos_humanos_view.dart

import 'package:flutter/material.dart';
import 'salario_view.dart';
import 'permiso_view.dart';
import 'vacaciones_view.dart';
// 🔹 Nuevos imports (pantallas que vas a crear)
import 'empleados_view.dart';
import 'acciones_personal_view.dart';
import 'agregar_empleado_view.dart';

class RecursosHumanosView extends StatelessWidget {
  const RecursosHumanosView({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = [
      {
        'titulo': 'Empleados',
        'icono': Icons.people,
        'color': Colors.blue,
        'vista': const EmpleadosView(),
      },
      {
        'titulo': 'Acciones de Personal',
        'icono': Icons.work,
        'color': Colors.green,
        'vista': const AccionesPersonalView(),
      },

    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Recursos Humanos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: opciones.map((opcion) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => opcion['vista'] as Widget),
                );
              },
              child: Card(
                elevation: 4,
                color: (opcion['color'] as Color).withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(opcion['icono'] as IconData, size: 50, color: Colors.white),
                      const SizedBox(height: 12),
                      Text(
                        opcion['titulo'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
