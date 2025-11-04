// lib/widgets/event_card.dart

import 'package:flutter/material.dart';
import 'package:my_app/models/event_model.dart';
import 'package:my_app/screens/event_detail_screen.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  // --- ESTADOS Y CONTADORES ---
  bool _isAttending = false;
  bool _isFavorite = false;
  late int _attendeeCount;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    // Inicializar los contadores con los valores del modelo
    _attendeeCount = widget.event.initialAttendees;
    _likeCount = widget.event.initialLikes;
  }

  void _toggleAttending() {
    setState(() {
      _isAttending = !_isAttending;
      if (_isAttending) {
        _attendeeCount++;
      } else {
        _attendeeCount--;
      }
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  // --- WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: widget.event),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- IMAGEN ---
            Image.network(
              widget.event.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
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

            // --- CONTENIDO DE TEXTO Y ACCIONES ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    widget.event.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Fecha y Ubicación
                  Text(
                    '${widget.event.date} | ${widget.event.location}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // 1. CONTADOR DE ASISTENTES (Línea Separada)
                  Text(
                    '$_attendeeCount personas asistirán',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[600],
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // 2. FILA DE ACCIONES (Botón Asistir | Likes/Compartir)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // A. BOTÓN ASISTIR (LADO IZQUIERDO)
                      TextButton.icon(
                        onPressed: _toggleAttending,
                        icon: Icon(
                          _isAttending
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: _isAttending ? Colors.blueAccent : Colors.grey,
                        ),
                        label: Text(
                          _isAttending ? 'Asistiré' : 'Asistir',
                          style: TextStyle(
                            color: _isAttending
                                ? Colors.blueAccent
                                : Colors.black,
                          ),
                        ),
                      ),

                      // B. LIKES/COMPARTIR (LADO DERECHO, Agrupado)
                      Row(
                        children: [
                          // CONTADOR DE LIKES
                          Text(
                            '$_likeCount',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Botón de Favorito
                          IconButton(
                            onPressed: _toggleFavorite,
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            color: _isFavorite ? Colors.redAccent : Colors.grey,
                          ),
                          // Botón de Compartir
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
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
