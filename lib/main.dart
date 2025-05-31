import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/productos/productos_view.dart';
import 'package:provider/provider.dart';
import 'auth/auth_view_model.dart';
import 'login/login_view_model.dart';
import 'productos/productos_view_model.dart';
import 'login/login_view.dart';
import 'home/home_view.dart';
import 'mantenimientos/mantenimiento_view.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProductosViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final authViewModel = Provider.of<AuthViewModel>(context);
        final bool isLoggedIn = authViewModel.isLoggedIn ?? false;
        return MaterialApp(
          title: 'Flutter App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          initialRoute: isLoggedIn ? '/home' : '/login',
          routes: {
            '/login': (_) => const LoginView(),
            '/home': (_) => const HomeView(),
            '/productos': (_) => const ProductosView(),
             '/mantenimientos': (_) => const MantenimientoView(),
            // '/imagenes': (_) => const ImagenesView(),
          },
        );
      },
    );
  }
}
