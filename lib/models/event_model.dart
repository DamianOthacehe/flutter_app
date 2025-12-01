// lib/models/event_model.dart

class Event {
  // 1. Las propiedades de nuestro evento (los "campos")
  final String id;
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final int initialAttendees;
  final int initialLikes;
  final String creatorId;
  final String creatorName;
  final String creatorImageUrl;
  final String creatorBio;
  final double price;
  final String time;

  // 2. El constructor
  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.initialAttendees,
    required this.initialLikes,
    required this.creatorId,
    required this.creatorName,
    required this.creatorImageUrl,
    required this.creatorBio,
    required this.price,
    required this.time,
  });
}
