import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'imagen_view_model.dart';

class ImagenView extends StatelessWidget {
  const ImagenView({super.key});

  Future<void> _seleccionarYSubirImagen(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final archivo = File(pickedFile.path);
      await Provider.of<ImagenViewModel>(context, listen: false).subirImagen(archivo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ImagenViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cargar Imagen')),
      body: Center(
        child: vm.subiendo
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => _seleccionarYSubirImagen(context),
                child: const Text('Seleccionar y Subir Imagen'),
              ),
      ),
    );
  }
}
