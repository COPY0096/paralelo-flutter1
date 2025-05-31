import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'imagen_view_model.dart';
import 'imagen_view.dart'; // La pantalla galería que creamos antes

class ImagenView extends StatefulWidget {
  const ImagenView({Key? key}) : super(key: key);

  @override
  _ImagenViewState createState() => _ImagenViewState();
}

class _ImagenViewState extends State<ImagenView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ImagenViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Subir Imagen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await viewModel.seleccionarYSubirImagen();
                // Aquí podrías mostrar un snackbar o alerta si quieres
              },
              child: const Text('Seleccionar y subir imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ImagenView()),
                );
              },
              child: const Text('Ver galería'),
            ),
          ],
        ),
      ),
    );
  }
}
