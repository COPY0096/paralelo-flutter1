//
import 'package:flutter/material.dart';

class ReabastecimientosHistorialView extends StatelessWidget {
  final List<Map<String, dynamic>> reabastecimientos = [
    {
      "id": 1,
      "producto": "Laptop Dell",
      "cantidad": 5,
      "fecha": "2025-08-15",
      "proveedor": "Tech Supplier SRL"
    },
    {
      "id": 2,
      "producto": "Mouse Logitech",
      "cantidad": 10,
      "fecha": "2025-08-12",
      "proveedor": "Distribuidora XYZ"
    },
  ];

  ReabastecimientosHistorialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Reabastecimientos"),
      ),
      body: reabastecimientos.isEmpty
          ? const Center(
              child: Text("No hay reabastecimientos registrados."),
            )
          : ListView.builder(
              itemCount: reabastecimientos.length,
              itemBuilder: (context, index) {
                final reab = reabastecimientos[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.inventory),
                    title: Text(reab["producto"]),
                    subtitle: Text(
                      "Cantidad: ${reab["cantidad"]}\nProveedor: ${reab["proveedor"]}\nFecha: ${reab["fecha"]}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
