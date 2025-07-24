// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_view_model.dart';
import 'login/login_view_model.dart';
import 'login/login_view.dart';
import 'home/home_view.dart';
import 'productos/productos_view.dart';
import 'productos/productos_view_model.dart';
import 'mantenimientos/mantenimiento_view.dart';
import 'imagenes/imagen_view.dart';
import 'imagenes/imagen_view_model.dart';
import 'imagenes/galeria_view.dart';
import 'usuarios/perfil_view.dart';
import 'theme/theme.dart';
import 'theme/theme_view_model.dart';

// Recursos Humanos
import 'mantenimientos/recursos_humanos/recursos_humanos_view.dart';
import 'mantenimientos/recursos_humanos/salario_view.dart';
import 'mantenimientos/recursos_humanos/permiso_view.dart';
import 'mantenimientos/recursos_humanos/vacaciones_view.dart';

import 'mantenimientos/recursos_humanos/salario_view_model.dart';
import 'mantenimientos/recursos_humanos/permiso_view_model.dart';
import 'mantenimientos/recursos_humanos/vacaciones_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProductosViewModel()),
        ChangeNotifierProvider(create: (_) => ImagenViewModel()),
        ChangeNotifierProvider(create: (_) => SalarioViewModel()),
        ChangeNotifierProvider(create: (_) => PermisoViewModel()),
        ChangeNotifierProvider(create: (_) => VacacionesViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()), // ← Nuevo
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = context.watch<ThemeViewModel>();

    return MaterialApp(
      title: 'SmartControl App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeVM.themeMode, // 👈 cambia según preferencia
      initialRoute: context.watch<AuthViewModel>().isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (_) => const LoginView(),
        '/home': (_) => const HomeView(),
        '/productos': (_) => const ProductosView(),
        '/mantenimientos': (_) => const MantenimientoView(),
        '/imagenes': (_) => const ImagenView(),
        '/galeria': (_) => const GaleriaView(),
        '/perfil': (_) => const PerfilView(),
        '/recursos-humanos': (_) => const RecursosHumanosView(),
        '/salarios': (_) => const SalarioView(),
        '/permisos': (_) => const PermisoView(),
        '/vacaciones': (_) => const VacacionesView(),
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'auth/auth_view_model.dart';
// import 'login/login_view_model.dart';
// import 'login/login_view.dart';
// import 'home/home_view.dart';
// import 'productos/productos_view.dart';
// import 'productos/productos_view_model.dart';
// import 'mantenimientos/mantenimiento_view.dart';
// import 'imagenes/imagen_view.dart';
// import 'imagenes/imagen_view_model.dart';
// import 'imagenes/galeria_view.dart';
// import 'usuarios/perfil_view.dart';
// import 'theme/theme.dart';

// // Recursos Humanos
// import 'mantenimientos/recursos_humanos/recursos_humanos_view.dart';
// import 'mantenimientos/recursos_humanos/salario_view.dart';
// import 'mantenimientos/recursos_humanos/permiso_view.dart';
// import 'mantenimientos/recursos_humanos/vacaciones_view.dart';

// import 'mantenimientos/recursos_humanos/salario_view_model.dart';
// import 'mantenimientos/recursos_humanos/permiso_view_model.dart';
// import 'mantenimientos/recursos_humanos/vacaciones_view_model.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthViewModel()),
//         ChangeNotifierProvider(create: (_) => LoginViewModel()),
//         ChangeNotifierProvider(create: (_) => ProductosViewModel()),
//         ChangeNotifierProvider(create: (_) => ImagenViewModel()),
//         ChangeNotifierProvider(create: (_) => SalarioViewModel()),
//         ChangeNotifierProvider(create: (_) => PermisoViewModel()),
//         ChangeNotifierProvider(create: (_) => VacacionesViewModel()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final authVM = context.watch<AuthViewModel>();
//     final isLoggedIn = authVM.isLoggedIn;
//     return MaterialApp(
//       title: 'SmartControl App',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       initialRoute: isLoggedIn ? '/home' : '/login',
//       routes: {
//         '/login': (_) => const LoginView(),
//         '/home': (_) => const HomeView(),
//         '/productos': (_) => const ProductosView(),
//         '/mantenimientos': (_) => const MantenimientoView(),
//         '/imagenes': (_) => const ImagenView(),
//         '/galeria': (_) => const GaleriaView(),
//         '/perfil': (_) => const PerfilView(),
//         // Recursos Humanos
//         '/recursos-humanos': (_) => const RecursosHumanosView(),
//         '/salarios': (_) => const SalarioView(),
//         '/permisos': (_) => const PermisoView(),
//         '/vacaciones': (_) => const VacacionesView(),
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_paralelo_1/productos/productos_view.dart';
// import 'package:provider/provider.dart';
// import 'auth/auth_view_model.dart';
// import 'login/login_view_model.dart';
// import 'productos/productos_view_model.dart';
// import 'login/login_view.dart';
// import 'home/home_view.dart';
// import 'mantenimientos/mantenimiento_view.dart';
// import 'imagenes/imagen_view.dart';
// import 'imagenes/imagen_view_model.dart';
// import 'imagenes/galeria_view.dart';
// import 'usuarios/perfil_view.dart';
// import 'theme/theme.dart';



// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthViewModel()),
//         ChangeNotifierProvider(create: (_) => LoginViewModel()),
//         ChangeNotifierProvider(create: (_) => ProductosViewModel()),
//         ChangeNotifierProvider(create: (_) => ImagenViewModel()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (context) {
//         final authViewModel = Provider.of<AuthViewModel>(context);
//         final bool isLoggedIn = authViewModel.isLoggedIn ?? false;
//         return MaterialApp(
//           title: 'SmartControl App',
//           debugShowCheckedModeBanner: false,
//           theme: AppTheme.lightTheme, //  Tema personalizado
//           initialRoute: isLoggedIn ? '/home' : '/login',
//           routes: {
//             '/login': (_) => const LoginView(),
//             '/home': (_) => const HomeView(),
//             '/productos': (_) => const ProductosView(),
//             '/mantenimientos': (_) => const MantenimientoView(),
//             '/imagenes': (_) => const ImagenView(),
//             '/galeria': (_) => const GaleriaView(),
//             '/perfil': (_) => const PerfilView(),
//           },
//         );
//       },
//     );
//   }
// }
