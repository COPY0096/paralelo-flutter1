import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualizarProductoView extends StatefulWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;

  ActualizarProductoView({required this.id, required this.nombre, required this.descripcion, required this.precio});

  @override
  _ActualizarProductoViewState createState() => _ActualizarProductoViewState();
}

class _ActualizarProductoViewState extends State<ActualizarProductoView> {
  late TextEditingController nombreController;
  late TextEditingController decripcionController;
  late TextEditingController precioController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.nombre);
    decripcionController = TextEditingController(text: widget.descripcion);
    precioController = TextEditingController(text: widget.precio.toString());
  }

  Future<void> actualizarProducto() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/api/productos/${widget.id}'),
      headers: {'Content-Type': 'application/json'},
      body: '{"nombre": "${nombreController.text}", "descripcion": "${decripcionController.text}", "precio": ${precioController.text}}',
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print('Error al actualizar producto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar Producto')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: decripcionController, decoration: InputDecoration(labelText: 'Descripción')),
            SizedBox(height: 10),
            TextField(controller: precioController, decoration: InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: actualizarProducto, child: Text('Actualizar')),
          ],
        ),
      ),
    );
  }
}




