// lib/widgets/event_card.dart

import 'package:flutter/material.dart';
import 'package:my_app/models/event_model.dart';
import 'package:my_app/screens/event_detail_screen.dart';
import 'package:my_app/screens/creator_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _attendeeCount = widget.event.initialAttendees;
    _likeCount = widget.event.initialLikes;
    _loadEventStatus();
  }

  // 🟢 CARGA EL ESTADO DE ASISTENCIA Y FAVORITO
  Future<void> _loadEventStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    // Usamos el ID del evento como llave única
    final isAttending = prefs.getBool('attending_${widget.event.id}') ?? false;
    final isFavorite = prefs.getBool('favorite_${widget.event.id}') ?? false;

    // Solo actualizamos el conteo si el estado en SharedPreferences es diferente
    if (isAttending != _isAttending) {
      _attendeeCount = isAttending ? _attendeeCount + 1 : _attendeeCount;
    }

    setState(() {
      _isAttending = isAttending;
      _isFavorite = isFavorite;
      // Nota: El conteo de likes lo dejamos fijo por ahora, solo la asistencia influye en el conteo total.
    });
  }

  // 🟢 GUARDA Y CAMBIA EL ESTADO DE ASISTENCIA
  void _toggleAttending() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAttending = !_isAttending;
      _attendeeCount = _isAttending ? _attendeeCount + 1 : _attendeeCount - 1;
      prefs.setBool('attending_${widget.event.id}', _isAttending);
    });
  }

  // 🟢 GUARDA Y CAMBIA EL ESTADO DE FAVORITO
  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = !_isFavorite;
      _likeCount = _isFavorite ? _likeCount + 1 : _likeCount - 1;
      // 🟢 GUARDA EL ESTADO
      prefs.setBool('favorite_${widget.event.id}', _isFavorite);
    });
  }

  // 🟢 FUNCIÓN DE NAVEGACIÓN AL DETALLE
  void _navigateToDetail(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(
          event: widget.event,
          onAttendingChanged: _loadEventStatus,
        ),
      ),
    );
    _loadEventStatus();
  }

  // 🟢 FUNCIÓN DE NAVEGACIÓN AL PERFIL DEL CREADOR
  void _navigateToCreatorProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatorProfileScreen(
          creatorId: widget.event.creatorId,
          creatorName: widget.event.creatorName,
          creatorImageUrl: widget.event.creatorImageUrl,
          creatorInstagram:
              '@${widget.event.creatorName.replaceAll(' ', '').toLowerCase()}', // Simulación de Instagram
          creatorBio: widget.event.creatorBio,
        ),
      ),
    );
  }

  // --- WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    // Usamos InkWell en el Card, pero la navegación principal la ponemos en el contenido
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟢 NUEVA SECCIÓN: Creador del Evento (Clickeable)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              12,
              12,
              0,
            ), // Espacio superior
            child: GestureDetector(
              onTap: () =>
                  _navigateToCreatorProfile(context), // Navegación al perfil
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(widget.event.creatorImageUrl),
                    backgroundColor: Colors.grey,
                    child: widget.event.creatorImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Publicado por ${widget.event.creatorName}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8.0), // Separador del header
          // --- IMAGEN (Usamos InkWell para que la imagen sea clickeable) ---
          InkWell(
            onTap: () => _navigateToDetail(context), // Navegación al detalle
            child: Image.network(
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
                  style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                const SizedBox(height: 12.0),

                // CONTADOR DE ASISTENTES
                Text(
                  '$_attendeeCount personas asistirán',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[600],
                  ),
                ),
                const SizedBox(height: 8.0),

                // FILA DE ACCIONES (Botón Asistir | Likes/Compartir)
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
                          onPressed: () {
                            // Implementar funcionalidad de compartir
                          },
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
    );
  }
}
