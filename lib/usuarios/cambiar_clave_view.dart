// lib/usuarios/cambiar_clave_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_view_model.dart';
import '../l10n/app_localizations.dart';
import 'usuario_service.dart';

class CambiarClaveView extends StatefulWidget {
  const CambiarClaveView({super.key});

  @override
  State<CambiarClaveView> createState() => _CambiarClaveViewState();
}

class _CambiarClaveViewState extends State<CambiarClaveView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController claveActualController = TextEditingController();
  final TextEditingController nuevaClaveController = TextEditingController();
  final TextEditingController confirmarClaveController = TextEditingController();
  
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    claveActualController.dispose();
    nuevaClaveController.dispose();
    confirmarClaveController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambio() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authViewModel = context.read<AuthViewModel>();
        final currentUser = authViewModel.user;

        if (currentUser == null) {
          _showErrorSnackBar('Usuario no autenticado');
          return;
        }

        // Validar que el ID del usuario sea válido
        if (currentUser.id == null || currentUser.id! <= 0) {
          _showErrorSnackBar('ID de usuario inválido');
          return;
        }

        // Log para debugging (puedes removerlo en producción)
        print('Cambiando clave para usuario ID: ${currentUser.id}');
        print('Username: ${currentUser.username}');
        print('Clave actual: ${claveActualController.text}');
        print('Nueva clave: ${nuevaClaveController.text}');

        final datos = {
          'claveActual': claveActualController.text,
          'nuevaClave': nuevaClaveController.text,
        };

        print('Datos a enviar: $datos');

        // Usar el método cambiarClaveDirecta que usa el endpoint /cambiar-clave
        final exito = await UsuarioService().cambiarClaveDirecta(
          currentUser.id!, // Este valor debe ser válido
          claveActualController.text.trim(),
          nuevaClaveController.text.trim(),
        );

        if (exito) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Contraseña cambiada correctamente'),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        print('Error al cambiar clave: $e'); // Log para debugging
        String errorMessage = e.toString().replaceAll('Exception: ', '');

        // Personalizar mensajes de error comunes
        if (errorMessage.contains('Contraseña actual incorrecta')) {
          errorMessage = 'La contraseña actual que ingresaste es incorrecta';
        } else if (errorMessage.contains('TimeoutException')) {
          errorMessage = 'Tiempo de espera agotado. Verifica tu conexión a internet';
        } else if (errorMessage.contains('SocketException')) {
          errorMessage = 'No se puede conectar al servidor. Verifica tu conexión';
        } else if (errorMessage.contains('La nueva clave es requerida')) {
          errorMessage = 'La nueva contraseña es requerida';
        } else if (errorMessage.contains('debe tener al menos 6 caracteres')) {
          errorMessage = 'La contraseña debe tener al menos 6 caracteres';
        }

        _showErrorSnackBar(errorMessage);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Cerrar',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Clave'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Actualizar Contraseña',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa tu contraseña actual y la nueva',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Mostrar información del usuario para debugging
              if (context.read<AuthViewModel>().user != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuario actual:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('ID: ${context.read<AuthViewModel>().user!.id}'),
                      Text('Username: ${context.read<AuthViewModel>().user!.username}'),
                      Text('Nombre: ${context.read<AuthViewModel>().user!.nombre}'),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Clave actual
              TextFormField(
                controller: claveActualController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Clave actual',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese su clave actual';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nueva clave
              TextFormField(
                controller: nuevaClaveController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Nueva clave',
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  helperText: 'Mínimo 6 caracteres',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese la nueva clave';
                  }
                  if (value.trim().length < 6) {
                    return 'La clave debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirmar nueva clave
              TextFormField(
                controller: confirmarClaveController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar nueva clave',
                  prefixIcon: const Icon(Icons.lock_clock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Confirme la nueva clave';
                  }
                  if (value.trim() != nuevaClaveController.text.trim()) {
                    return 'Las claves no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Información de seguridad
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Se requiere la contraseña actual para verificar tu identidad.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _guardarCambio,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isLoading ? 'Guardando...' : 'Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}