// lib/screens/event_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/models/event_model.dart'; // Asegúrate de que esta ruta sea correcta

class EventDetailScreen extends StatefulWidget {
  final Event event;
  // Callback para notificar a la tarjeta cuando el estado de asistencia cambia.
  final VoidCallback? onAttendingChanged;

  const EventDetailScreen({
    super.key,
    required this.event,
    this.onAttendingChanged,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  // Estado para el botón de asistir (simulación)
  bool _isAttending = false;
  late int _attendeeCount;

  // URL base simulada para el mapa (debe ser 'https://maps.google.com/?q=' para funcionar en la práctica)
  static const String _mapBaseUrl = 'https://maps.google.com/?q=';

  @override
  void initState() {
    super.initState();
    _attendeeCount = widget.event.initialAttendees;
    _loadDetailStatus(); // Cargar estado persistente
  }

  // CARGA EL ESTADO DE ASISTENCIA PERSISTENTE
  Future<void> _loadDetailStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    // Usamos el ID del evento como llave única
    final isAttending = prefs.getBool('attending_${widget.event.id}') ?? false;

    setState(() {
      _isAttending = isAttending;
      // Ajustamos el conteo inicial basado en el estado persistente
      _attendeeCount = widget.event.initialAttendees + (isAttending ? 1 : 0);
    });
  }

  // TOGGLE ASISTIR (CON PERSISTENCIA Y NOTIFICACIÓN)
  void _toggleAttending() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isAttending = !_isAttending;
      _attendeeCount = _isAttending ? _attendeeCount + 1 : _attendeeCount - 1;
    });

    // 1. GUARDA EL NUEVO ESTADO
    await prefs.setBool('attending_${widget.event.id}', _isAttending);

    // 2. NOTIFICA AL PADRE (la EventCard)
    widget.onAttendingChanged?.call();

    // Feedback visual
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAttending ? '¡Confirmaste asistencia!' : 'Asistencia cancelada.',
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  // FUNCIÓN PARA ABRIR EL MAPA
  Future<void> _launchMap() async {
    final locationQuery = Uri.encodeComponent(widget.event.location);
    // Usamos la URL real de Google Maps para mejor compatibilidad
    final url = '$_mapBaseUrl$locationQuery';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la aplicación de mapas.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. SLIVER APP BAR (con imagen y título único)
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true, // Esto mantiene el título visible al scrollear
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              // Título único que se fija al fondo de la imagen
              title: Text(
                widget.event.title,
                style: const TextStyle(
                  color: Colors.white, // Color blanco para el texto
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    // Sombra fuerte para asegurar la legibilidad sobre cualquier imagen
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              // Ajustamos la posición del título para que aparezca abajo en el estado expandido
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),

              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen de fondo
                  Image.network(
                    widget.event.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Gradiente oscuro fuerte (Asegura la legibilidad del título)
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black45, // Más suave arriba
                          Colors
                              .black87, // Más oscuro abajo (donde está el título)
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. CONTENIDO PRINCIPAL
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Detalles clave (Horario, Precio, Organizador) ---
                    _buildInfoRow(
                      Icons.schedule,
                      'Horario',
                      widget.event.time,
                      Colors.blueAccent,
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      'Precio',
                      widget.event.price == 0.0
                          ? 'Gratis'
                          : '\$${widget.event.price.toStringAsFixed(2)}',
                      Colors.green,
                    ),
                    _buildInfoRow(
                      Icons.person,
                      'Organizador',
                      widget.event.creatorName,
                      Colors.purple,
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    // --- Mapa Simulado y Ubicación ---
                    Text(
                      'Ubicación: ${widget.event.location}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _launchMap,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.map,
                                size: 40,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ver Mapa (Abrir en Google Maps)',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              Text(
                                widget.event.location,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Divider(),

                    // --- Descripción o Detalles Adicionales ---
                    const Text(
                      'Acerca del Evento:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Aquí se mostraría la descripción completa del evento, mucho más detallada que el título. Por ahora, este es un texto de relleno para mantener la estructura visual.',
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      // 3. BOTÓN FLOTANTE/BARRA INFERIOR (Asistir y Asistentes)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cantidad de Asistentes
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_attendeeCount',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Personas Asistirán',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            // Botón Asistir (Sincronizado)
            ElevatedButton.icon(
              onPressed: _toggleAttending,
              icon: Icon(
                _isAttending ? Icons.check_circle_outline : Icons.group_add,
                color: Colors.white,
              ),
              label: Text(
                _isAttending ? '¡Ya Asistes!' : 'Asistir',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAttending
                    ? Colors.green
                    : Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función auxiliar para construir filas de información
  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
