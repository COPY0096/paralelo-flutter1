// lib/login/login_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import '../models/user_model.dart';
import '../auth/auth_view_model.dart';
import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  late final AppLinks _appLinks;
  late final StreamSubscription<Uri> _linkSubscription;

  @override
  void initState() {
    super.initState();
    _listenToLinks();
  }

  void _listenToLinks() async {
    _appLinks = AppLinks();

    // Captura link cuando la app ya está abierta
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleIncomingLink(uri);
    });

    // Captura link si la app fue abierta por primera vez por el link
    final initialUri = await _appLinks.getInitialAppLink();
    if (initialUri != null) {
      _handleIncomingLink(initialUri);
    }
  }

  void _handleIncomingLink(Uri uri) async {
    if (uri.scheme == 'myapp' && uri.host == 'login-success') {
      final token = uri.queryParameters['token'];
      final username = uri.queryParameters['username'];
      final id = uri.queryParameters['id'];
      final rol = uri.queryParameters['rol'];

      if (token != null && username != null && id != null && rol != null) {
        print('🔑 Token recibido: $token');
        print('👤 Usuario autenticado: $username con rol: $rol');

        // Autocompleta los campos de texto en pantalla
        setState(() {
          _usernameController.text = username;
          _passwordController.text = 'github'; // Valor ficticio si lo necesitas
        });

        // Crear usuario directamente con los datos de GitHub
        final user = UserModel(
          id: int.tryParse(id) ?? 0,
          username: username,
          nombre: username,
          correo: '', // Se puede obtener más adelante
          rol: rol,
        );
        
        // Guardar usuario en AuthViewModel
        context.read<AuthViewModel>().login(user);

        // Si tienes lógica personalizada en loginAndNavigate, ejecútala
        await context.read<LoginViewModel>().loginAndNavigate(
          context,
          username,
          'github', // O un token simulado si es necesario
        );
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.lock_outline, size: 80, color: theme.colorScheme.primary),
                const SizedBox(height: 24),

                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: localizations.username,
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localizations.password,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () async {
                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    await context.read<LoginViewModel>().loginAndNavigate(
                      context,
                      username,
                      password,
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: Text(localizations.loginButton),
                ),
                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    // Funcionalidad futura para recuperar contraseña
                  },
                  child: Text(localizations.forgotPassword),
                ),
                const SizedBox(height: 30),

                const Divider(),
                const SizedBox(height: 10),
                Text(localizations.loginWithOtherMethods),
                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<LoginViewModel>().loginWithGitHub();
                  },
                  icon: const Icon(Icons.code),
                  label: const Text("Iniciar con GitHub"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),

                // Mostrar mensaje del ViewModel si existe
                Consumer<LoginViewModel>(
                  builder: (context, loginVM, child) {
                    if (loginVM.message.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          loginVM.message,
                          style: TextStyle(
                            color: loginVM.message.contains('exitoso') 
                                ? Colors.green 
                                : Colors.red,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}