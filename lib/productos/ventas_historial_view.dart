//
import 'package:flutter/material.dart';

class VentasHistorialView extends StatelessWidget {
  final List<Map<String, dynamic>> ventas = [
    {
      "id": 1,
      "producto": "Laptop Dell",
      "cantidad": 2,
      "precio": 35000.0,
      "total": 70000.0,
      "fecha": "2025-08-20"
    },
    {
      "id": 2,
      "producto": "Mouse Logitech",
      "cantidad": 3,
      "precio": 1200.0,
      "total": 3600.0,
      "fecha": "2025-08-18"
    },
  ];

  VentasHistorialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Ventas"),
      ),
      body: ventas.isEmpty
          ? const Center(
              child: Text("No hay ventas registradas."),
            )
          : ListView.builder(
              itemCount: ventas.length,
              itemBuilder: (context, index) {
                final venta = ventas[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: Text(venta["producto"]),
                    subtitle: Text(
                      "Cantidad: ${venta["cantidad"]}\nFecha: ${venta["fecha"]}",
                    ),
                    trailing: Text(
                      "\$${venta["total"].toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
