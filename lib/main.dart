// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_paralelo_1/theme/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'auth/auth_view_model.dart';
import 'login/login_view_model.dart';
import 'productos/productos_view_model.dart';
import 'imagenes/imagen_view_model.dart';
import 'mantenimientos/recursos_humanos/salario_view_model.dart';
import 'mantenimientos/recursos_humanos/permiso_view_model.dart';
import 'mantenimientos/recursos_humanos/vacaciones_view_model.dart';
import 'theme/theme.dart';
import 'locale/locale_provider.dart';
import 'locale/app_localizations_delegate.dart'; // Asegúrate de tener este archivo
import 'login/login_view.dart';
import 'home/home_view.dart';
import 'productos/productos_view.dart';
import 'mantenimientos/mantenimiento_view.dart';
import 'imagenes/imagen_view.dart';
import 'imagenes/galeria_view.dart';
import 'usuarios/perfil_view.dart';
import 'mantenimientos/recursos_humanos/recursos_humanos_view.dart';
import 'mantenimientos/recursos_humanos/salario_view.dart';
import 'mantenimientos/recursos_humanos/permiso_view.dart';
import 'mantenimientos/recursos_humanos/vacaciones_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

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
        ChangeNotifierProvider(create: (_) => localeProvider),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()), // ← Aquí
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      title: 'SmartControl App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeViewModel>().themeMode,
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('es')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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

