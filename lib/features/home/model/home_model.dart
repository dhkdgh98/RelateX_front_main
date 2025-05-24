class TimelineEntry {
  final String title;
  final String friend;
  final String? location;
  final String? imageUrl;
  final String? content;
  final String? emotion;
  final String? category;
  final String? recordType;  // 여기에 추가해쪄~
  final DateTime date;

  TimelineEntry({
    required this.title,
    required this.friend,
    this.location,
    this.imageUrl,
    this.content,
    this.emotion,
    this.category,
    this.recordType,  // 생성자에도 추가 꼭~
    required this.date,
  });

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      title: json['title'] as String,
      friend: json['friend'] as String,
      location: json['location'] as String?,
      imageUrl: json['imageUrl'] as String?,
      content: json['content'] as String?,
      emotion: json['emotion'] as String?,
      category: json['category'] as String?,
      recordType: json['recordType'] as String?,  // 이거도 넣기
      date: DateTime.parse(json['date'] as String),
    );
  }
}

final List<TimelineEntry> mockEntries = [
  TimelineEntry(
    date: DateTime(2025, 4, 28),
    friend: '태훈',
    title: '불안한 마음',
    location: '카페거리',
    content: '오늘은 불안함을 느끼며, 이를 받아들이려고 노력했다.',
    recordType: '이벤트',
    emotion: '불안',
    category: '자기성찰',
  ),
  TimelineEntry(
    date: DateTime(2025, 3, 15),
    friend: '영호',
    title: '긍정적인 변화',
    location: '도서관',
    content: '새로운 시작을 위해 다짐하며 공부했다.',
    recordType: '이벤트',
    emotion: '자신감',
    category: '성장',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 10),
    friend: '나 자신',
    title: '자기반성',
    location: '내 방',
    content: '하루를 되돌아보며 감정 정리를 했다. 나 자신에게 솔직해지는 연습을 하고 있다.',
    recordType: '이벤트',
    emotion: '차분함',
    category: '자기성찰',
  ),
  TimelineEntry(
    date: DateTime(2025, 5, 2),
    friend: '세정',
    title: '새로운 시작',
    location: '공원',
    content: '새로운 도전을 시작한 날이었다. 두려움도 있지만 기대가 크다.',
    recordType: '이벤트',
    emotion: '설렘',
    category: '성장',
    imageUrl: 'https://via.placeholder.com/60',
  ),
];
