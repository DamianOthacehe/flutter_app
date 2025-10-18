// lib/widgets/event_card.dart

import 'package:flutter/material.dart';
// 1. Importamos nuestro modelo
import 'package:my_app/models/event_model.dart';

class EventCard extends StatelessWidget {
  // 2. Declaramos la "prop" que vamos a recibir
  final Event event;

  // 3. Actualizamos el constructor para aceptar el evento
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            event.imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            // Placeholder mientras carga
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            // Placeholder si falla la carga
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 5. Usamos los datos del evento en lugar de texto fijo
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),

                Text(
                  '${event.date} | ${event.location}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                const SizedBox(height: 12.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        /* Acción de asistir */
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Asistiré'),
                    ),
                    IconButton(
                      onPressed: () {
                        /* Acción de favorito */
                      },
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
