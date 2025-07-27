import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.productListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: localizations.addProduct,
            onPressed: () {
              // Acción futura para agregar producto
            },
          ),
        ],
      ),
      body: productos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text('${localizations.price}: \$${producto.precio.toStringAsFixed(2)}'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.point_of_sale),
                          tooltip: localizations.sellProduct,
                          onPressed: () {
                            // Acción futura para vender producto
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: localizations.editProduct,
                          onPressed: () {
                            // Acción futura para editar producto
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: localizations.deleteProduct,
                          onPressed: () {
                            // Acción futura para eliminar producto
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
