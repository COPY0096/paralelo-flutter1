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
    context.read<ProductosViewModel>().cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductosViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Productos')),
      body: viewModel.cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.productos.length,
              itemBuilder: (context, index) {
                final producto = viewModel.productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Precio: \$${producto.precio.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
