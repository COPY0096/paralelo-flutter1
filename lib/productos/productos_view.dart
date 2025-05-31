import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'productos_view_model.dart';

class ProductosView extends StatefulWidget {
  const ProductosView({super.key});

  @override
  State<ProductosView> createState() => _ProductosViewState();
}

class _ProductosViewState extends State<ProductosView> {
  @override
  void initState() {
    super.initState();
    // Llama a fetchProductos una vez que el widget se haya inicializado
    Future.microtask(() {
      Provider.of<ProductosViewModel>(context, listen: false).fetchProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductosViewModel>(context);
    final productos = viewModel.productos;

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Productos')),
      body: productos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Precio: \$${producto.precio.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
