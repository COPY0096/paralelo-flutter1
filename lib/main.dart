import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_view_model.dart';
import 'login_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVVM Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const LoginView(),
    );
  }
}
