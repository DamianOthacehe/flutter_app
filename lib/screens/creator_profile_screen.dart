// lib/screens/creator_profile_screen.dart (VERSION FINAL CON PERSISTENCIA SIMULADA)

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ⬅️ Para persistencia simulada
import 'package:my_app/models/event_model.dart';
import 'package:my_app/widgets/event_card.dart';

class CreatorProfileScreen extends StatefulWidget {
  final String creatorId;
  final String creatorName;
  final String creatorImageUrl;
  final String creatorInstagram;
  final String creatorBio; // ⬅️ Nuevo: Biografía para mostrar

  const CreatorProfileScreen({
    super.key,
    required this.creatorId,
    required this.creatorName,
    required this.creatorImageUrl,
    required this.creatorInstagram,
    required this.creatorBio,
  });

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  bool _isFollowing = false;

  // 1. Simulación de otros eventos publicados (usaremos un filtro simple)
  // En una app real, esta lista vendría de un API.
  final List<Event> _allDummyEvents = const [
    // Usamos los mismos datos que en HomeScreen para simplicidad
    // Asegúrate de que los creatorId coincidan
    Event(
      id: 'e1',
      title: 'Festival de Jazz en el Parque',
      date: 'Vie, 10 Nov',
      location: 'Parque Central',
      imageUrl:
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA4OTh8MHwxfHNlYXJjaHwxfHxqYXp6JTIwY29uY2VydHxlbnwwfHx8fDE2NzM5MjI0NTE&ixlib=rb-4.0.3&q=80&w=400',
      initialAttendees: 150,
      initialLikes: 45,
      creatorId: 'c1',
      creatorName: 'Música Viva',
      creatorImageUrl:
          'https://images.unsplash.com/photo-1595971294624-80bcf0d7eb24?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bXVzaWNpYW58ZW58MHx8MHx8fDA%3D',
      creatorBio:
          'Somos un colectivo dedicado a promover la música en vivo y el arte local.',
      price: 0.0,
      time: '19:00 - 22:00',
    ),
    Event(
      id: 'e2',
      title: 'Conferencia de Tech "FutureNow"',
      date: 'Mar, 14 Nov',
      location: 'Centro de Convenciones',
      imageUrl:
          'https://images.unsplash.com/photo-1582192730841-2a682d7375f9?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=774',
      initialAttendees: 200,
      initialLikes: 98,
      creatorId: 'c2',
      creatorName: 'Innovación Tech',
      creatorImageUrl:
          'https://plus.unsplash.com/premium_photo-1750235095427-03dfa05bf952?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw1OHx8fGVufDB8fHx8fA%3D%3D',
      creatorBio:
          'Líderes en conferencias sobre inteligencia artificial y el futuro digital.',
      price: 45.99,
      time: '09:00 - 17:00',
    ),
    // Evento adicional para el creador c1 (Música Viva)
    Event(
      id: 'ce1',
      title: 'Taller de Composición Musical',
      date: 'Mar, 5 Dic',
      location: 'Conservatorio',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1664194584256-5c940e4e7ecf?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGNvbXBvc2luZyUyMG11c2ljfGVufDB8fDB8fHww',
      initialAttendees: 30,
      initialLikes: 5,
      creatorId: 'c1',
      creatorName: 'Música Viva',
      creatorImageUrl:
          'https://images.unsplash.com/photo-1595971294624-80bcf0d7eb24?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bXVzaWNpYW58ZW58MHx8MHx8fDA%3D',
      creatorBio:
          'Somos un colectivo dedicado a promover la música en vivo y el arte local.',
      price: 15.00,
      time: '18:00 - 20:00',
    ),
  ];

  // 2. Filtramos al iniciar (solo los eventos creados por este creador)
  late List<Event> _creatorEvents;

  @override
  void initState() {
    super.initState();
    _loadFollowStatus();
    _creatorEvents = _allDummyEvents
        .where((event) => event.creatorId == widget.creatorId)
        .toList();
  }

  // 🟢 LÓGICA DE PERSISTENCIA SIMULADA
  Future<void> _loadFollowStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Usamos el creatorId como llave de guardado
      _isFollowing = prefs.getBool('follow_${widget.creatorId}') ?? false;
    });
  }

  Future<void> _toggleFollow() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _isFollowing = !_isFollowing;
      // Guardamos el nuevo estado en el dispositivo
      prefs.setBool('follow_${widget.creatorId}', _isFollowing);
    });

    // Opcional: Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? '¡Siguiendo a ${widget.creatorName}!'
              : 'Dejaste de seguir a ${widget.creatorName}.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 🟢 FUNCIÓN DE LINK EXTERNO
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(
      'https://instagram.com/$url',
    ); // Asumimos que es Instagram
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir Instagram: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Creador')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. SECCIÓN SUPERIOR: AVATAR, NOMBRE y BIO DINÁMICA ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Imagen del Perfil
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.creatorImageUrl),
                    backgroundColor: Colors.grey,
                    child: widget.creatorImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Nombre del Creador
                  Text(
                    widget.creatorName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botones de Acción (Seguir y Enlace)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botón Seguir (con estado persistente simulado)
                      ElevatedButton.icon(
                        onPressed: _toggleFollow,
                        icon: Icon(
                          _isFollowing ? Icons.check : Icons.person_add,
                          color: Colors.white,
                        ),
                        label: Text(
                          _isFollowing ? 'Siguiendo' : 'Seguir',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFollowing
                              ? Colors.grey
                              : Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Link a Instagram
                      IconButton(
                        onPressed: () => _launchURL(widget.creatorInstagram),
                        icon: const Icon(
                          Icons.link,
                          color: Colors.purple,
                          size: 30,
                        ),
                        tooltip: 'Ver Instagram',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 🟢 Biografía Dinámica
                  Text(
                    widget
                        .creatorBio, // ⬅️ Usa la biografía pasada por parámetro
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // --- 2. SECCIÓN: OTROS EVENTOS ---
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Otros eventos publicados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // 🟢 Lista de Eventos Publicados (Muestra solo los eventos filtrados)
            if (_creatorEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No hay otros eventos publicados por este creador.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            // Usamos un ListView.builder para los eventos filtrados
            ListView.builder(
              shrinkWrap:
                  true, // Importante para usarlo dentro de SingleChildScrollView
              physics:
                  const NeverScrollableScrollPhysics(), // Evita scroll anidado
              itemCount: _creatorEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: _creatorEvents[index]);
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
