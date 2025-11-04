// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:my_app/widgets/event_card.dart';
import 'package:my_app/models/event_model.dart';
import 'package:my_app/screens/profile_screen.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🟢 1. ESTADO PARA LA IMAGEN DE PERFIL LOCAL
  File? _profileImageFile;
  String _currentBio = "Bio por defecto...";
  final String _userProfileImageUrl =
      'https://images.unsplash.com/photo-1623038896180-d81dd785a60f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870';

  // 2. Creamos nuestra lista de datos falsos (mock data)
  final List<Event> dummyEvents = const [
    Event(
      id: 'e1',
      title: 'Festival de Jazz en el Parque',
      date: 'Vie, 10 Nov',
      location: 'Parque Central',
      imageUrl:
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA4OTh8MHwxfHNlYXJjaHwxfHxqYXp6JTIwY29uY2VydHxlbnwwfHx8fDE2NzM5MjI0NTE&ixlib=rb-4.0.3&q=80&w=400',
      initialAttendees: 150,
      initialLikes: 45,
    ),
    Event(
      id: 'e2',
      title: 'Conferencia de Tech "FutureNow"',
      date: 'Mar, 14 Nov',
      location: 'Centro de Convenciones',
      imageUrl:
          'https://images.unsplash.com/photo-1582192730841-2a682d7375f9?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=774',
      initialAttendees: 150,
      initialLikes: 45,
    ),
    Event(
      id: 'e3',
      title: 'Noche de Comedia con "Risas Mil"',
      date: 'Jue, 16 Nov',
      location: 'Teatro Apolo',
      imageUrl:
          'https://images.unsplash.com/photo-1641903806973-17eaf2d2634f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
      initialAttendees: 150,
      initialLikes: 45,
    ),
    Event(
      id: 'e4',
      title: 'Recaudación de Fondos "Un Techo"',
      date: 'Sáb, 18 Nov',
      location: 'Hotel Hilton',
      imageUrl:
          'https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
      initialAttendees: 150,
      initialLikes: 45,
    ),
  ];
  // 🟢 2. FUNCIÓN PARA NAVEGAR Y ESPERAR EL RESULTADO
  void _navigateToProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // Enviamos la imagen actual para que ProfileScreen la muestre
        builder: (context) => ProfileScreen(
          initialImage: _profileImageFile,
          initialBio: _currentBio,
        ),
      ),
    );

    if (!mounted) return;
    // Si recibimos un resultado de Map, actualizamos el estado
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _profileImageFile = result['imageFile'] as File?;
        _currentBio = result['bio'] as String; // 🟢 ACTUALIZAMOS LA BIO
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Perfil de usuario actualizado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 3. DETERMINAR LA IMAGEN DE FONDO
    ImageProvider backgroundImage;
    if (_profileImageFile != null) {
      // Usar la imagen local si fue seleccionada
      backgroundImage = FileImage(_profileImageFile!);
    } else {
      // Usar la imagen de red por defecto
      backgroundImage = NetworkImage(_userProfileImageUrl);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPlan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _navigateToProfile, // ⬅️ Usamos la nueva función
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                // 🟢 SOLUCIÓN 3: USAR ÚNICAMENTE EL BACKGROUNDIMAGE
                backgroundImage: backgroundImage,

                // Fallback: Si no hay imagen local y la URL por defecto está vacía
                child: _profileImageFile == null && _userProfileImageUrl.isEmpty
                    ? const Icon(Icons.person, size: 24, color: Colors.grey)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummyEvents.length,
        itemBuilder: (context, index) {
          return EventCard(event: dummyEvents[index]);
        },
      ),
    );
  }
}
