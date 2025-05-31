import 'dart:io';
import 'package:flutter/foundation.dart';
import 'imagen_service.dart';

class ImagenViewModel extends ChangeNotifier {
  bool _subiendo = false;
  bool get subiendo => _subiendo;

  final ImagenService _service = ImagenService();

  Future<void> subirImagen(File imagen) async {
    _subiendo = true;
    notifyListeners();

    final resultado = await compute<File, String?>(_subirEnSegundoPlano, imagen);

    _subiendo = false;
    notifyListeners();

    if (resultado != null) {
      // Puedes guardar o mostrar la URL recibida
      print("Imagen subida con éxito: $resultado");
    }
  }

  static Future<String?> _subirEnSegundoPlano(File imagen) async {
    return await ImagenService().subirImagen(imagen);
  }
}
