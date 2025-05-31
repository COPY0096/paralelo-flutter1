import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'imagen_service.dart';

// Función auxiliar para procesar la imagen en un isolate
File _procesarImagen(String path) {
  // Aquí podrías aplicar compresión, redimensionamiento, etc.
  return File(path);
}

// Método externo para ejecutar _procesarImagen usando compute
Future<File> procesarImagenEnIsolate(File archivo) async {
  return compute(_procesarImagen, archivo.path);
}

class ImagenViewModel extends ChangeNotifier {
  final ImagenService _service = ImagenService();

  List<String> imagenes = [];
  bool cargando = false;
  String? mensaje;

  // Método para seleccionar y subir imagen sin bloquear el hilo principal
  Future<void> seleccionarYSubirImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      cargando = true;
      notifyListeners();

      try {
        final archivoProcesado = await procesarImagenEnIsolate(File(pickedFile.path));
        final response = await _service.subirImagen(archivoProcesado);

        mensaje = response['mensaje'] ?? 'Imagen subida exitosamente';

        // Recargar imágenes después de subir
        await cargarImagenes();
      } catch (e) {
        mensaje = 'Error al subir imagen: $e';
      }

      cargando = false;
      notifyListeners();
    } else {
      mensaje = 'No se seleccionó ninguna imagen';
      notifyListeners();
    }
  }

  // Método para cargar las imágenes del servidor
  Future<void> cargarImagenes() async {
    cargando = true;
    notifyListeners();

    try {
      imagenes = await _service.obtenerImagenes();
      mensaje = imagenes.isEmpty ? 'No hay imágenes para mostrar' : null;
    } catch (e) {
      imagenes = [];
      mensaje = 'Error al cargar imágenes: $e';
    }

    cargando = false;
    notifyListeners();
  }
}
