// lib/mantenimientos/recursos_humanos/salario_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'salario_model.dart';
import 'salario_view_model.dart';

class SalarioView extends StatefulWidget {
  const SalarioView({super.key});

  @override
  State<SalarioView> createState() => _SalarioViewState();
}

class _SalarioViewState extends State<SalarioView> {
  final TextEditingController _usuarioIdController = TextEditingController();
  final TextEditingController _salarioController = TextEditingController(); // ← corregido

  @override
  void initState() {
    super.initState();
    context.read<SalarioViewModel>().loadSalarios();
  }

  void _mostrarFormulario({Salario? salario}) {
    final isEdit = salario != null;
    _usuarioIdController.text = isEdit ? salario.usuarioId.toString() : '';
    _salarioController.text = isEdit ? salario.salario.toString() : ''; // ← corregido

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Editar Salario' : 'Nuevo Salario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usuarioIdController,
              decoration: const InputDecoration(labelText: 'ID Usuario'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _salarioController, // ← corregido
              decoration: const InputDecoration(labelText: 'Salario'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final usuarioId = int.tryParse(_usuarioIdController.text.trim());
              final salarioValor = double.tryParse(_salarioController.text.trim());

              if (usuarioId != null && salarioValor != null) {
                final nuevoSalario = Salario(
                  id: salario?.id,
                  usuarioId: usuarioId,
                  salario: salarioValor, // ← corregido
                  fechaAsignacion: DateTime.now(),
                );

                if (isEdit) {
                  await context.read<SalarioViewModel>().updateSalario(nuevoSalario);
                } else {
                  await context.read<SalarioViewModel>().addSalario(nuevoSalario);
                }

                Navigator.pop(context);
              }
            },
            child: Text(isEdit ? 'Actualizar' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SalarioViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Salarios')),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.error.isNotEmpty
              ? Center(child: Text('Error: ${viewModel.error}'))
              : ListView.builder(
                  itemCount: viewModel.salarios.length,
                  itemBuilder: (_, index) {
                    final salario = viewModel.salarios[index];
                    return Card(
                      child: ListTile(
                        title: Text('Usuario ID: ${salario.usuarioId}'),
                        subtitle: Text(
                          'Salario: RD\$${salario.salario.toStringAsFixed(2)}\n'
                          'Fecha: ${salario.fechaAsignacion.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _mostrarFormulario(salario: salario),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => context.read<SalarioViewModel>().deleteSalario(salario.id!),
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
