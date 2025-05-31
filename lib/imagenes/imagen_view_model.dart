import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'imagen_service.dart';

class ImagenViewModel extends ChangeNotifier {
  final ImagenService _service = ImagenService();

  List<String> imagenes = [];
  bool cargando = false;
  String? mensaje;

  // Método para seleccionar y subir imagen
  Future<void> seleccionarYSubirImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final archivo = File(pickedFile.path);
      try {
        final response = await _service.subirImagen(archivo);
        mensaje = response['mensaje'] ?? 'Imagen subida';
      } catch (e) {
        mensaje = 'Error al subir imagen';
      }
      notifyListeners();
    } else {
      mensaje = 'No se seleccionó ninguna imagen';
      notifyListeners();
    }
  }

  Future<void> cargarImagenes() async {
    cargando = true;
    notifyListeners();

    try {
      imagenes = await _service.obtenerImagenes();
    } catch (e) {
      imagenes = [];
    }

    cargando = false;
    notifyListeners();
  }
}