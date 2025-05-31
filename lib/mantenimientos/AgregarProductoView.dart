import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarProductoView extends StatefulWidget {
  @override
  _AgregarProductoViewState createState() => _AgregarProductoViewState();
}

class _AgregarProductoViewState extends State<AgregarProductoView> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  Future<void> agregarProducto() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/productos'),
      headers: {'Content-Type': 'application/json'},
      body: '{"nombre": "${nombreController.text}","descripcion": "${descripcionController.text}", "precio": ${precioController.text}}',
    );

    if (response.statusCode == 200) {
      Navigator.pop(context); // Regresa a la lista
    } else {
      print('Error al agregar producto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Producto')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: descripcionController, decoration: InputDecoration(labelText: 'Descripción')),
            TextField(controller: precioController, decoration: InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: agregarProducto, child: Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
