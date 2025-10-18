// lib/main.dart

import 'package:flutter/material.dart';
// 1. Importamos la pantalla que acabamos de crear.
import 'package:my_app/screens/home_screen.dart'; // Asegúrate que la ruta sea correcta.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp es el widget raíz de la aplicación. Configura temas, rutas, etc.
    return MaterialApp(
      title: 'MyPlan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Quita la molesta banda de "Debug"
      // 2. Aquí le decimos a la app cuál es la pantalla de inicio.
      home: const HomeScreen(),
    );
  }
}
