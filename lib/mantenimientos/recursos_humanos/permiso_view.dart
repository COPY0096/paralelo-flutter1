// lib/mantenimientos/recursos_humanos/permiso_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'permiso_model.dart';
import 'permiso_view_model.dart';

class PermisoView extends StatefulWidget {
  const PermisoView({super.key});

  @override
  State<PermisoView> createState() => _PermisoViewState();
}

class _PermisoViewState extends State<PermisoView> {
  final _usuarioController = TextEditingController();
  final _tipoController = TextEditingController();
  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<PermisoViewModel>().loadPermisos();
  }

  void _mostrarFormulario({Permiso? permiso}) {
    final localizations = AppLocalizations.of(context)!;
    final isEdit = permiso != null;

    _usuarioController.text = permiso?.usuarioId.toString() ?? '';
    _tipoController.text = permiso?.tipo ?? '';
    _fechaInicio = permiso?.fechaInicio ?? DateTime.now();
    _fechaFin = permiso?.fechaFin ?? DateTime.now();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit
            ? localizations.editPermission
            : localizations.newPermission),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(labelText: localizations.userId),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tipoController,
              decoration:
                  InputDecoration(labelText: localizations.permissionType),
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
              child: Text(
                  '${localizations.start}: ${_fechaInicio.toLocal().toString().split(' ')[0]}'),
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
              child: Text(
                  '${localizations.end}: ${_fechaFin.toLocal().toString().split(' ')[0]}'),
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
              final usuarioId = int.tryParse(_usuarioController.text.trim());
              if (usuarioId == null || _tipoController.text.isEmpty) return;

              final nuevo = Permiso(
                id: permiso?.id,
                usuarioId: usuarioId,
                tipo: _tipoController.text,
                fechaInicio: _fechaInicio,
                fechaFin: _fechaFin,
              );

              final vm = context.read<PermisoViewModel>();
              if (isEdit) {
                await vm.updatePermiso(nuevo);
              } else {
                await vm.addPermiso(nuevo);
              }

              Navigator.pop(context);
            },
            child: Text(isEdit ? localizations.update : localizations.save),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PermisoViewModel>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.permissions)),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.error.isNotEmpty
              ? Center(child: Text('Error: ${vm.error}'))
              : ListView.builder(
                  itemCount: vm.permisos.length,
                  itemBuilder: (_, index) {
                    final p = vm.permisos[index];
                    return Card(
                      child: ListTile(
                        title: Text('Usuario ID: ${p.usuarioId}'),
                        subtitle: Text('${p.tipo} del ${p.fechaInicio.toLocal().toString().split(' ')[0]} al ${p.fechaFin.toLocal().toString().split(' ')[0]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _mostrarFormulario(permiso: p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => vm.deletePermiso(p.id!),
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
