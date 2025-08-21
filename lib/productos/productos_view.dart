//lib/productos/productos_view.dart
import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'productos_view_model.dart';
import 'producto_service.dart';

class ProductosView extends StatefulWidget {
  const ProductosView({super.key});

  @override
  State<ProductosView> createState() => _ProductosViewState();
}

class _ProductosViewState extends State<ProductosView> {
  final ProductoService _productoService = ProductoService();

  @override
  void initState() {
    super.initState();
    // Llama a fetchProductos una vez que el widget se haya inicializado
    Future.microtask(() {
      Provider.of<ProductosViewModel>(context, listen: false).fetchProductos();
    });
  }

  // Diálogo para seleccionar cantidad a vender
  Future<int?> _mostrarDialogoCantidad(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cantidad a vender'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Ej: 2',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final cantidad = int.tryParse(controller.text);
              if (cantidad != null && cantidad > 0) {
                Navigator.pop(context, cantidad);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor ingresa una cantidad válida'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Vender'),
          ),
        ],
      ),
    );
  }

  // Diálogo para seleccionar cantidad a reabastecer
  Future<int?> _mostrarDialogoReabastecer(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cantidad a reabastecer'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Ej: 10',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.add_box, color: Colors.blue),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final cantidad = int.tryParse(controller.text);
              if (cantidad != null && cantidad > 0) {
                Navigator.pop(context, cantidad);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cantidad inválida'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Reabastecer'),
          ),
        ],
      ),
    );
  }

  // Función para vender producto
  Future<void> _venderProducto(int productoId, String nombreProducto) async {
    try {
      final cantidad = await _mostrarDialogoCantidad(context);
      if (cantidad == null) return; // Usuario canceló

      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Realizar venta
      final resultado = await _productoService.venderProducto(productoId, cantidad);
      
      // Cerrar indicador de carga
      Navigator.pop(context);

      // Mostrar resultado exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Venta exitosa: $cantidad unidad(es) de $nombreProducto\n'
            'Stock restante: ${resultado['producto']['stockActual']}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Actualizar lista de productos
      Provider.of<ProductosViewModel>(context, listen: false).fetchProductos();

    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // Función para reabastecer producto
  Future<void> _reabastecerProducto(int productoId, String nombreProducto) async {
    try {
      final cantidad = await _mostrarDialogoReabastecer(context);
      if (cantidad == null) return; // Usuario canceló

      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Realizar reabastecimiento
      final resultado = await _productoService.reabastecerProducto(productoId, cantidad);

      // Cerrar indicador de carga
      Navigator.pop(context);

      // Mostrar resultado exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se reabasteció $cantidad unidad(es) de $nombreProducto\n'
            'Nuevo stock: ${resultado['producto']['stockActual']}',
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 3),
        ),
      );

      // Actualizar lista de productos
      Provider.of<ProductosViewModel>(context, listen: false).fetchProductos();

    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
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
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () {
              viewModel.fetchProductos();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: localizations.addProduct,
            onPressed: () {
              // Acción futura para agregar producto
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial',
            onPressed: () {
              // Acción futura para ver historial
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
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${localizations.price}: \$${producto.precio.toStringAsFixed(2)}'),
                        const SizedBox(height: 2),
                        Text(
                          producto.stockFormatted,
                          style: TextStyle(
                            color: producto.estaAgotado 
                                ? Colors.red[700]
                                : producto.stockBajo 
                                    ? Colors.orange[700]
                                    : Colors.grey[700],
                            fontWeight: producto.estaAgotado || producto.stockBajo 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        ),
                        if (producto.descripcion.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            producto.descripcion,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.point_of_sale,
                            color: producto.estaAgotado ? Colors.grey : Colors.green,
                          ),
                          tooltip: producto.estaAgotado 
                              ? 'Sin stock' 
                              : localizations.sellProduct,
                          onPressed: producto.estaAgotado 
                              ? null 
                              : () => _venderProducto(producto.id, producto.nombre),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_box, color: Colors.blue),
                          tooltip: 'Reabastecer',
                          onPressed: () => _reabastecerProducto(producto.id, producto.nombre),
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
