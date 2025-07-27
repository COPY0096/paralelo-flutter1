// lib/mantenimientos/recursos_humanos/salario_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
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
  final TextEditingController _salarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SalarioViewModel>().loadSalarios();
  }

  void _mostrarFormulario({Salario? salario}) {
    final isEdit = salario != null;
    final localizations = AppLocalizations.of(context)!;

    _usuarioIdController.text = isEdit ? salario.usuarioId.toString() : '';
    _salarioController.text = isEdit ? salario.salario.toString() : '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? localizations.editSalary : localizations.newSalary),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usuarioIdController,
              decoration: InputDecoration(labelText: localizations.userId),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _salarioController,
              decoration: InputDecoration(labelText: localizations.salary),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final usuarioId = int.tryParse(_usuarioIdController.text.trim());
              final salarioValor = double.tryParse(_salarioController.text.trim());

              if (usuarioId != null && salarioValor != null) {
                final nuevoSalario = Salario(
                  id: salario?.id,
                  usuarioId: usuarioId,
                  salario: salarioValor,
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
            child: Text(isEdit ? localizations.update : localizations.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SalarioViewModel>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.salaries)),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.error.isNotEmpty
              ? Center(child: Text('${localizations.error}: ${viewModel.error}'))
              : ListView.builder(
                  itemCount: viewModel.salarios.length,
                  itemBuilder: (_, index) {
                    final salario = viewModel.salarios[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.attach_money, color: Colors.green),
                        title: Text('${localizations.userId}: ${salario.usuarioId}'),
                        subtitle: Text(
                          '${localizations.salary}: RD\$${salario.salario.toStringAsFixed(2)}\n'
                          '${localizations.date}: ${salario.fechaAsignacion.toLocal().toString().split(' ')[0]}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _mostrarFormulario(salario: salario),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
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
