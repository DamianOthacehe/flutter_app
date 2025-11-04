// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:my_app/widgets/event_card.dart';
import 'package:my_app/models/event_model.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPlan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        // 3. Usamos el largo de nuestra lista real
        itemCount: dummyEvents.length,
        itemBuilder: (BuildContext context, int index) {
          // 4. Creamos una variable para el evento actual
          final event = dummyEvents[index];

          // 5. Pasamos el objeto 'event' completo a nuestro widget
          return EventCard(event: event);
        },
      ),
    );
  }
}
