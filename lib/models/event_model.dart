// lib/models/event_model.dart

class Event {
  // 1. Las propiedades de nuestro evento (los "campos")
  final String id;
  final String title;
  final String date;
  final String location;
  final String imageUrl;

  // 2. El constructor
  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
  });
}
