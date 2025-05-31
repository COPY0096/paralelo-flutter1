import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login/login_view_model.dart';
import 'productos/productos_view_model.dart';
import 'auth/auth_view_model.dart'; 
import 'login/login_view.dart';
import 'home/home_view.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProductosViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()), // NUEVO
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          return auth.isLoggedIn ? const HomeView() : const LoginView();
        },
      ),
    );
  }
}
