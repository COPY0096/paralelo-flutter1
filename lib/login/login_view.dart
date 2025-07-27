import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_paralelo_1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  onPressed: () {
                    // Funcionalidad futura para login con GitHub
                  },
                  icon: const Icon(Icons.code),
                  label: const Text("GitHub"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}