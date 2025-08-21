// lib/mantenimientos/recursos_humanos/empleados_view.dart
import 'package:flutter/material.dart';
import '../../models/empleado_model.dart';
import '../../services/empleado_service.dart';

class EmpleadosView extends StatefulWidget {
  const EmpleadosView({super.key});

  @override
  State<EmpleadosView> createState() => _EmpleadosViewState();
}

class _EmpleadosViewState extends State<EmpleadosView> {
  late Future<List<Empleado>> _empleados;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  void _cargarEmpleados() {
    setState(() {
      _empleados = EmpleadoService.getEmpleados();
    });
  }

  void _eliminarEmpleado(int id, String nombre) async {
    // Mostrar diálogo de confirmación
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar al empleado "$nombre"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        setState(() => _isLoading = true);
        await EmpleadoService.deleteEmpleado(id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Empleado "$nombre" eliminado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarEmpleados();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar empleado: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _editarEmpleado(Empleado empleado) async {
    final TextEditingController nombreCtrl = TextEditingController(text: empleado.nombre);
    final TextEditingController cedulaCtrl = TextEditingController(text: empleado.cedula ?? '');
    final TextEditingController correoCtrl = TextEditingController(text: empleado.correo ?? '');
    final TextEditingController cargoCtrl = TextEditingController(text: empleado.cargo ?? '');
    final TextEditingController salarioCtrl = TextEditingController(text: empleado.salario?.toString() ?? '0');
    final TextEditingController passwordCtrl = TextEditingController();
    
    String? rolSeleccionado = empleado.rol ?? 'operador';

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Editar Empleado"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nombre Completo *",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cedulaCtrl,
                      decoration: const InputDecoration(
                        labelText: "Cédula *",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cargoCtrl,
                      decoration: const InputDecoration(
                        labelText: "Cargo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: salarioCtrl,
                      decoration: const InputDecoration(
                        labelText: "Salario",
                        border: OutlineInputBorder(),
                        prefixText: '\$ ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: correoCtrl,
                      decoration: const InputDecoration(
                        labelText: "Correo Electrónico",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nueva Contraseña (opcional)",
                        border: OutlineInputBorder(),
                        hintText: "Dejar vacío para mantener actual",
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: rolSeleccionado,
                      items: ['admin', 'operador', 'invitado']
                          .map((rol) => DropdownMenuItem(
                              value: rol, 
                              child: Text(rol.toUpperCase())
                            ))
                          .toList(),
                      onChanged: (val) => setState(() => rolSeleccionado = val),
                      decoration: const InputDecoration(
                        labelText: 'Rol',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validar campos requeridos
                    if (nombreCtrl.text.trim().isEmpty ||
                        cedulaCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nombre y Cédula son obligatorios'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      // Preparar datos del empleado usando la estructura requerida
                      final empleadoData = {
                        "nombre": nombreCtrl.text.trim(),
                        "cedula": cedulaCtrl.text.trim(),
                        "cargo": cargoCtrl.text.trim().isNotEmpty ? cargoCtrl.text.trim() : null,
                        "salario": salarioCtrl.text.trim().isNotEmpty 
                            ? double.tryParse(salarioCtrl.text.trim()) ?? 0 
                            : 0,
                        "correo": correoCtrl.text.trim().isNotEmpty ? correoCtrl.text.trim() : null,
                        "password": passwordCtrl.text.trim().isNotEmpty ? passwordCtrl.text.trim() : null,
                        "rol": rolSeleccionado,
                      };

                      print("📤 Datos del empleado a actualizar: $empleadoData");

                      // Usar el servicio de actualización
                      await EmpleadoService.actualizarEmpleadoConDatos(empleado.id!, empleadoData);
                      Navigator.pop(context, true);
                    } catch (e) {
                      print("⚠️ Error al actualizar empleado: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al actualizar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empleado actualizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _cargarEmpleados();
    }
  }

  void _agregarEmpleado() async {
    final TextEditingController nombreCtrl = TextEditingController();
    final TextEditingController cedulaCtrl = TextEditingController();
    final TextEditingController correoCtrl = TextEditingController();
    final TextEditingController cargoCtrl = TextEditingController();
    final TextEditingController salarioCtrl = TextEditingController();
    final TextEditingController usernameCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();
    
    String? _rol = 'operador'; // Valor por defecto

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Agregar Empleado"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nombre Completo *",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cedulaCtrl,
                      decoration: const InputDecoration(
                        labelText: "Cédula *",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: correoCtrl,
                      decoration: const InputDecoration(
                        labelText: "Correo Electrónico",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cargoCtrl,
                      decoration: const InputDecoration(
                        labelText: "Cargo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: salarioCtrl,
                      decoration: const InputDecoration(
                        labelText: "Salario",
                        border: OutlineInputBorder(),
                        prefixText: '\$ ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      "Datos de Usuario (Opcional)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: usernameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordCtrl,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _rol,
                      items: ['admin', 'operador', 'invitado']
                          .map((rol) => DropdownMenuItem(
                              value: rol, 
                              child: Text(rol.toUpperCase())
                            ))
                          .toList(),
                      onChanged: (val) => setState(() => _rol = val),
                      decoration: const InputDecoration(
                        labelText: 'Rol',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validar campos requeridos
                    if (nombreCtrl.text.trim().isEmpty ||
                        cedulaCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nombre y Cédula son obligatorios'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Validar datos de usuario si se proporcionan
                    if (usernameCtrl.text.trim().isNotEmpty ||
                        passwordCtrl.text.trim().isNotEmpty) {
                      if (usernameCtrl.text.trim().isEmpty ||
                          passwordCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Si creas usuario, Username y Password son obligatorios'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                    }

                    try {
                      // Preparar datos del empleado
                      final empleadoData = {
                        "nombre": nombreCtrl.text.trim(),
                        "cedula": cedulaCtrl.text.trim(),
                        "correo": correoCtrl.text.trim().isNotEmpty ? correoCtrl.text.trim() : null,
                        "cargo": cargoCtrl.text.trim().isNotEmpty ? cargoCtrl.text.trim() : null,
                        "salario": salarioCtrl.text.trim().isNotEmpty 
                            ? double.tryParse(salarioCtrl.text.trim()) ?? 0 
                            : 0,
                      };

                      // Agregar datos de usuario si se proporcionan
                      if (usernameCtrl.text.trim().isNotEmpty && 
                          passwordCtrl.text.trim().isNotEmpty) {
                        empleadoData["usuario"] = {
                          "username": usernameCtrl.text.trim(),
                          "password": passwordCtrl.text.trim(),
                          "rol": _rol,
                        };
                      }

                      await EmpleadoService.agregarEmpleadoConUsuario(empleadoData);
                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error al agregar empleado: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Agregar"),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empleado agregado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _cargarEmpleados(); // 👈 refresca la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Gestión de Empleados"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _agregarEmpleado,
            tooltip: 'Agregar empleado',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarEmpleados,
            tooltip: 'Actualizar lista',
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Empleado>>(
            future: _empleados,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Error al cargar empleados",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _cargarEmpleados,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No hay empleados registrados",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Agrega el primer empleado para comenzar",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _agregarEmpleado,
                        icon: const Icon(Icons.person_add),
                        label: const Text('Agregar Empleado'),
                      ),
                    ],
                  ),
                );
              } else {
                final empleados = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    _cargarEmpleados();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: empleados.length,
                    itemBuilder: (context, index) {
                      final empleado = empleados[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Text(
                              empleado.nombre.isNotEmpty 
                                  ? empleado.nombre[0].toUpperCase()
                                  : 'E',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            empleado.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "👤 ${empleado.username}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                "🏷️ ${empleado.rol}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                "📧 ${empleado.correo ?? 'Sin correo'}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                "💼 ${empleado.cargo ?? 'Sin cargo'}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                "💰 \$${empleado.salario?.toStringAsFixed(2) ?? '0.00'}",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "🆔 ${empleado.cedula ?? 'Sin cédula'}",
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editarEmpleado(empleado),
                                tooltip: 'Editar empleado',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _eliminarEmpleado(empleado.id!, empleado.nombre),
                                tooltip: 'Eliminar empleado',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarEmpleado,
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar'),
      ),
    );
  }
}
