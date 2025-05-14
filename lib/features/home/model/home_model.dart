// home_model.dart

class TimelineEntry {
  final DateTime date;
  final String friendName;
  final String title;
  final String location;
  final String content;
  final String emotion;
  final String category;

  TimelineEntry({
    required this.date,
    required this.friendName,
    required this.title,
    required this.location,
    required this.content,
    required this.emotion,
    required this.category,
  });
}
