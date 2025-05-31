import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class ProductosViewModel extends ChangeNotifier {
  List<Producto> productos = [];
  bool cargando = false;

  final ProductoService _productoService = ProductoService();

  Future<void> cargarProductos() async {
    cargando = true;
    notifyListeners();

    try {
      productos = await _productoService.fetchProductos();
    } catch (e) {
      // Manejo de error
      print('Error al cargar productos: $e');
    }

    cargando = false;
    notifyListeners();
  }
}
