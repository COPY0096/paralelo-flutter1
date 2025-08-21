// lib/mantenimientos/recursos_humanos/acciones_personal_view.dart
import 'package:flutter/material.dart';
import '../../models/empleado_model.dart';
import '../../services/empleado_service.dart';
import 'acciones_personal_service.dart';

class AccionesPersonalView extends StatefulWidget {
  const AccionesPersonalView({super.key});

  @override
  State<AccionesPersonalView> createState() => _AccionesPersonalViewState();
}

class _AccionesPersonalViewState extends State<AccionesPersonalView> {
  late Future<List<Empleado>> _empleados;

  @override
  void initState() {
    super.initState();
    _empleados = EmpleadoService.getEmpleados();
  }

  void _refrescar() {
    setState(() {
      _empleados = EmpleadoService.getEmpleados();
    });
  }

  Future<void> _abrirAccionesEmpleado(Empleado e) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              runSpacing: 8,
              children: [
                ListTile(
                  leading: const Icon(Icons.beach_access, color: Colors.blue),
                  title: const Text('Registrar Vacaciones'),
                  subtitle: const Text('Fechas, motivo, días calculados'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _dialogVacaciones(e);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payments, color: Colors.green),
                  title: const Text('Registrar Pago de Salario'),
                  subtitle: Text('Sueldo base: \$${(e.salario ?? 0).toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _dialogPagoSalario(e);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.request_page, color: Colors.orange),
                  title: const Text('Gestionar Permisos'),
                  subtitle: const Text('Solicitudes y aprobaciones'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _dialogPermisos(e);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.purple),
                  title: const Text('Ver Historial'),
                  subtitle: const Text('Vacaciones, pagos y permisos'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _verHistorial(e);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _dialogVacaciones(Empleado e) async {
    DateTime? inicio;
    DateTime? fin;
    final motivoCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setLocal) {
          // Calcular días si ambas fechas están seleccionadas
          int diasVacaciones = 0;
          if (inicio != null && fin != null) {
            diasVacaciones = fin!.difference(inicio!).inDays + 1;
          }

          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.beach_access, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(child: Text('Vacaciones - ${e.nombre}')),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            diasVacaciones > 0 
                                ? 'Días de vacaciones: $diasVacaciones'
                                : 'Selecciona las fechas para calcular días',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_month, color: Colors.green),
                  title: Text(inicio == null
                      ? 'Fecha inicio'
                      : 'Inicio: ${inicio!.toIso8601String().substring(0,10)}'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setLocal(() => inicio = picked);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.red),
                  title: Text(fin == null
                      ? 'Fecha fin'
                      : 'Fin: ${fin!.toIso8601String().substring(0,10)}'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: inicio?.add(const Duration(days: 1)) ?? DateTime.now(),
                      firstDate: inicio ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setLocal(() => fin = picked);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: motivoCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Motivo (opcional)',
                    hintText: 'Vacaciones familiares, descanso, etc.',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: diasVacaciones > 0 ? () async {
                  try {
                    await AccionesPersonalService.crearVacacion(
                      empleadoId: e.id!,
                      fechaInicio: inicio!.toIso8601String().substring(0,10),
                      fechaFin: fin!.toIso8601String().substring(0,10),
                      motivo: motivoCtrl.text.trim().isEmpty ? null : motivoCtrl.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vacaciones registradas: $diasVacaciones días'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $err'), backgroundColor: Colors.red),
                    );
                  }
                } : null,
                child: const Text('Guardar'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _dialogPagoSalario(Empleado e) async {
    final montoCtrl = TextEditingController(text: (e.salario ?? 0).toStringAsFixed(2));
    DateTime? pIni;
    DateTime? pFin;
    DateTime? fPago = DateTime.now();
    String metodo = 'transferencia';
    final comentarioCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setLocal) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.payments, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text('Pago de salario - ${e.nombre}')),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: montoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monto a pagar',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Periodo de pago (opcional)', 
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          ListTile(
                            leading: const Icon(Icons.date_range, color: Colors.blue),
                            title: Text(pIni == null
                                ? 'Desde (opcional)'
                                : 'Desde: ${pIni!.toIso8601String().substring(0,10)}'),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: DateTime.now().subtract(const Duration(days: 30)),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setLocal(() => pIni = picked);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.date_range_outlined, color: Colors.blue),
                            title: Text(pFin == null
                                ? 'Hasta (opcional)'
                                : 'Hasta: ${pFin!.toIso8601String().substring(0,10)}'),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: DateTime.now(),
                                firstDate: pIni ?? DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setLocal(() => pFin = picked);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.event_available, color: Colors.green),
                    title: Text('Fecha de pago: ${fPago!.toIso8601String().substring(0,10)}'),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setLocal(() => fPago = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: metodo,
                    items: const [
                      DropdownMenuItem(value: 'transferencia', 
                          child: Row(children: [Icon(Icons.account_balance), SizedBox(width: 8), Text('Transferencia')])),
                      DropdownMenuItem(value: 'efectivo', 
                          child: Row(children: [Icon(Icons.money), SizedBox(width: 8), Text('Efectivo')])),
                      DropdownMenuItem(value: 'nomina', 
                          child: Row(children: [Icon(Icons.assignment), SizedBox(width: 8), Text('Nómina')])),
                      DropdownMenuItem(value: 'cheque', 
                          child: Row(children: [Icon(Icons.receipt), SizedBox(width: 8), Text('Cheque')])),
                    ],
                    onChanged: (v) => setLocal(() => metodo = v ?? 'transferencia'),
                    decoration: const InputDecoration(
                      labelText: 'Método de pago',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: comentarioCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Comentarios (opcional)',
                      hintText: 'Bonos, descuentos, notas especiales...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () async {
                  final monto = double.tryParse(montoCtrl.text.trim());
                  if (monto == null || monto <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Monto inválido'), backgroundColor: Colors.red),
                    );
                    return;
                  }
                  if (pIni != null && pFin != null && pFin!.isBefore(pIni!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rango de periodo inválido'), backgroundColor: Colors.red),
                    );
                    return;
                  }
                  try {
                    await AccionesPersonalService.crearPagoSalario(
                      empleadoId: e.id!,
                      monto: monto,
                      periodoInicio: pIni?.toIso8601String().substring(0,10),
                      periodoFin: pFin?.toIso8601String().substring(0,10),
                      fechaPago: fPago?.toIso8601String().substring(0,10),
                      metodo: metodo,
                      comentarios: comentarioCtrl.text.trim().isEmpty ? null : comentarioCtrl.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pago registrado: \$${monto.toStringAsFixed(2)}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $err'), backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text('Registrar Pago'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _dialogPermisos(Empleado e) async {
    // Implementación futura para gestión de permisos
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Gestión de Permisos'),
        content: const Text('Funcionalidad en desarrollo.\n\nPermitirá gestionar:\n• Solicitudes de permisos\n• Aprobaciones\n• Tipos de permisos\n• Historial'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Future<void> _verHistorial(Empleado e) async {
    // Implementación futura para ver historial
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Historial - ${e.nombre}'),
        content: const Text('Funcionalidad en desarrollo.\n\nMostrará:\n• Historial de vacaciones\n• Historial de pagos\n• Historial de permisos\n• Reportes detallados'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acciones de Personal'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: _refrescar,
            tooltip: 'Actualizar lista',
          ),
          IconButton(
            icon: const Icon(Icons.analytics), 
            onPressed: () {
              // Funcionalidad futura: reportes generales
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reportes generales en desarrollo')),
              );
            },
            tooltip: 'Reportes',
          ),
        ],
      ),
      body: FutureBuilder<List<Empleado>>(
        future: _empleados,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando empleados...'),
                ],
              ),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snap.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refrescar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          final data = snap.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay empleados registrados'),
                  SizedBox(height: 8),
                  Text('Agrega empleados para gestionar acciones de personal', 
                       style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (ctx, i) {
              final e = data[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      e.nombre.isNotEmpty ? e.nombre[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  title: Text(
                    e.nombre, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (e.cargo != null && e.cargo!.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.work, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${e.cargo}'),
                          ],
                        ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text('Salario: \$${(e.salario ?? 0).toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.more_vert, color: Colors.blue),
                  ),
                  onTap: () => _abrirAccionesEmpleado(e),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
