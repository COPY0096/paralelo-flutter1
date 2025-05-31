import 'package:flutter/material.dart';
import 'producto.dart';
import 'producto_service.dart';

class ProductosViewModel extends ChangeNotifier {
  final ProductoService _productoService = ProductoService();
  List<Producto> _productos = [];
  List<Producto> get productos => _productos;

  Future<void> fetchProductos() async {
    _productos = await _productoService.fetchProductos();
    notifyListeners();
  }
}
