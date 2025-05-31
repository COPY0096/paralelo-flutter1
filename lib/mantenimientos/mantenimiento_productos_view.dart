import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AgregarProductoView.dart';
import 'ActualizarProductoView.dart';

class MantenimientoProductoView extends StatefulWidget {
  const MantenimientoProductoView({super.key});
  @override
  _MantenimientoProductoViewState createState() =>
      _MantenimientoProductoViewState();
}

class _MantenimientoProductoViewState extends State<MantenimientoProductoView> {
  List productos = [];

  Future<void> fetchProductos() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/productos'),
    );

    if (response.statusCode == 200) {
      setState(() {
        productos = jsonDecode(response.body);
      });
    } else {
      print('Error al cargar productos');
    }
  }

  Future<void> eliminarProducto(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:3000/api/productos/$id'),
    );

    if (response.statusCode == 200) {
      fetchProductos();
    } else {
      print('Error al eliminar producto');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mantenimiento de Productos')),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return ListTile(
            title: Text(producto['nombre']),
            subtitle: Text('Precio: \$${producto['precio']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActualizarProductoView(
                          id: producto['id'],
                          nombre: producto['nombre'],
                          descripcion: producto['descripcion'] ?? '',
                          precio:
                              double.tryParse(producto['precio'].toString()) ??
                              0,
                        ),
                      ),
                    );
                    fetchProductos(); // Recarga productos al volver
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => eliminarProducto(producto['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AgregarProductoView()),
          );
          fetchProductos(); // Recarga productos al volver
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
