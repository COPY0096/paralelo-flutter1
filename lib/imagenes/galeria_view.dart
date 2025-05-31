import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'imagen_view_model.dart';


class GaleriaView extends StatelessWidget {
  const GaleriaView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ImagenViewModel>(context);

    if (!viewModel.cargando && viewModel.imagenes.isEmpty) {
      viewModel.cargarImagenes();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Galería de Imágenes')),
      body: viewModel.cargando
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: viewModel.imagenes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Image.network(
                    'http://10.0.2.2:3000${viewModel.imagenes[index]}',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}
