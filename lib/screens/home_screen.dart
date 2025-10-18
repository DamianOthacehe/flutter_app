// lib/screens/home_screen.dart

// Es como hacer 'import React from 'react''. Nos da acceso a los widgets básicos de Material Design.
import 'package:flutter/material.dart';

// Definimos nuestro widget. Hereda de StatelessWidget.
class HomeScreen extends StatelessWidget {
  // El constructor, por ahora lo dejamos así.
  const HomeScreen({super.key});

  // Este es el método más importante. Es el equivalente al 'render()' de React.
  // Describe cómo se debe construir la UI de este widget.
  @override
  Widget build(BuildContext context) {
    // Scaffold es un widget que nos da la estructura básica de una pantalla
    // (barra de navegación, cuerpo, botones flotantes, etc.). ¡Es súper útil!
    return Scaffold(
      // La barra de navegación superior, como un <header>.
      appBar: AppBar(
        title: const Text('MyPlan'), // El widget para mostrar texto.
        backgroundColor: Colors.blueAccent, // Vamos a darle un colorcito.
      ),
      // El cuerpo principal de la pantalla, como el <body>.
      body: const Center(
        // Un widget que centra a su hijo en el medio de la pantalla.
        child: Text('Aquí irá nuestro Feed de Eventos'),
      ),
    );
  }
}
