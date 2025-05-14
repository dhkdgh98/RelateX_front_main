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
// 💾 목업 데이터
final List<TimelineEntry> mockEntries = [
  TimelineEntry(
    date: DateTime(2025, 5, 13),
    friendName: '민지',
    title: '진심을 담은 대화',
    location: '카카오톡',
    content: '오늘은 민지랑 오랜만에 연락했다. 예전의 나처럼 행동하지 않고 진심을 담아 대화하려고 노력한 날이었다.',
    emotion: '감동',
    category: '관계',
  ),
  TimelineEntry(
    date: DateTime(2025, 5, 12),
    friendName: '나 자신',
    title: '자기반성',
    location: '내 방',
    content: '자기 전에 오늘 하루를 되돌아보며 감정 정리를 했다. 나 자신에게 솔직해지는 연습을 하고 있다.',
    emotion: '차분함',
    category: '자기성찰',
  ),
  TimelineEntry(
    date: DateTime(2025, 5, 11),
    friendName: '혼자',
    title: '조용한 하루',
    location: '카페거리',
    content: '오늘은 아무와도 연락하지 않았지만, 오히려 그게 마음의 평화를 줬다.',
    emotion: '평온',
    category: '마음관리',
  ),
];
