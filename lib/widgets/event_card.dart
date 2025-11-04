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
  bool _isFavorite = false;
  bool _isAttending = false; // Añadimos una para "Asistiré"

  void _toggleFavorite() {
    // Usamos setState() para notificar a Flutter que la UI debe re-dibujarse.
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _toggleAttending() {
    setState(() {
      _isAttending = !_isAttending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // Usamos 'widget.event' en lugar de solo 'event'
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
            Image.network(
              widget.event.imageUrl, // 'widget.event'
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title, // 'widget.event'
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${widget.event.date} | ${widget.event.location}', // 'widget.event'
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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

                      IconButton(
                        onPressed: _toggleFavorite,

                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),

                        color: _isFavorite ? Colors.redAccent : Colors.grey,
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
