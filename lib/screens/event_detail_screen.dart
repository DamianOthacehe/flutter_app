// lib/screens/event_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:my_app/models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event.date} | ${event.location}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Acerca de este evento',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Descripción (por ahora, un texto de relleno)
                  const Text(
                    'Aquí irá la descripción completa del evento... por ahora es un texto de relleno. Esta información vendrá desde tu API de FastAPI. '
                    'Según tu documento, aquí también iría la lista de asistentes (GET /events/{event_id}).',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
