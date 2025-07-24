// lib/mantenimientos/recursos_humanos/vacaciones_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vacaciones_model.dart';
import 'vacaciones_view_model.dart';

class VacacionesView extends StatefulWidget {
  const VacacionesView({super.key});

  @override
  State<VacacionesView> createState() => _VacacionesViewState();
}

class _VacacionesViewState extends State<VacacionesView> {
  final _usuarioController = TextEditingController();
  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<VacacionesViewModel>().cargarVacaciones();
  }

  void _mostrarFormulario({Vacaciones? vac}) {
    final isEdit = vac != null;
    _usuarioController.text = vac?.usuarioId.toString() ?? '';
    _fechaInicio = vac?.fechaInicio ?? DateTime.now();
    _fechaFin = vac?.fechaFin ?? DateTime.now();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Editar Vacaciones' : 'Nuevas Vacaciones'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'ID Usuario'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fechaInicio,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _fechaInicio = picked);
              },
              child: Text('Inicio: ${_fechaInicio.toLocal().toString().split(' ')[0]}'),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fechaFin,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _fechaFin = picked);
              },
              child: Text('Fin: ${_fechaFin.toLocal().toString().split(' ')[0]}'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final usuarioId = int.tryParse(_usuarioController.text.trim());
              if (usuarioId == null) return;

              final nuevo = Vacaciones(
                id: vac?.id,
                usuarioId: usuarioId,
                fechaInicio: _fechaInicio,
                fechaFin: _fechaFin,
              );

              final vm = context.read<VacacionesViewModel>();
              if (isEdit) {
                await vm.actualizarVacaciones(nuevo);
              } else {
                await vm.agregarVacaciones(nuevo);
              }

              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Actualizar' : 'Guardar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VacacionesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Vacaciones')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.error.isNotEmpty
              ? Center(child: Text('Error: ${vm.error}'))
              : ListView.builder(
                  itemCount: vm.lista.length,
                  itemBuilder: (_, index) {
                    final vac = vm.lista[index];
                    return Card(
                      child: ListTile(
                        title: Text('Usuario ID: ${vac.usuarioId}'),
                        subtitle: Text(
                            'Del ${vac.fechaInicio.toLocal().toString().split(' ')[0]} al ${vac.fechaFin.toLocal().toString().split(' ')[0]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _mostrarFormulario(vac: vac),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => vm.eliminarVacaciones(vac.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
