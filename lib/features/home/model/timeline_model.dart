class TimelineEntry {
  final String? id;
  final String title;
  final String friend;
  final String? location;
  final List<String>? imageUrls;      // ✅ 여러 이미지 URL
  final List<String>? imagesBase64;   // ✅ Base64 이미지 리스트
  final String? content;
  final String? emotion;
  final String? category;
  final String? recordType;           // ✅ 기록 유형 (텍스트, 사진 등)
  final DateTime date;

  TimelineEntry({
    this.id,
    required this.title,
    required this.friend,
    this.location,
    this.imageUrls,
    this.imagesBase64,
    this.content,
    this.emotion,
    this.category,
    this.recordType,
    required this.date,
  });

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      id: json['_id'] != null ? json['_id'].toString() : null,
      title: json['title'] ?? '',
      friend: json['friend'] ?? '',
      location: json['location'],
      imageUrls: (json['imageUrls'] as List?)?.map((e) => e.toString()).toList(),
      imagesBase64: (json['imagesBase64'] as List?)?.map((e) => e.toString()).toList(),
      content: json['content'],
      emotion: json['emotion'],
      category: json['category'],
      recordType: json['recordType'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? '',
      'title': title,
      'friend': friend,
      'location': location,
      'imageUrls': imageUrls,
      'imagesBase64': imagesBase64,
      'content': content,
      'emotion': emotion,
      'category': category,
      'recordType': recordType,
      'date': date.toIso8601String(),
    };
  }
}


final List<TimelineEntry> mockEntries = [
  TimelineEntry(
    id: '1',
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
    id: '2',
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
    id: '3',
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
    id: '4',
    date: DateTime(2025, 5, 2),
    friend: '세정',
    title: '새로운 시작',
    location: '공원',
    content: '새로운 도전을 시작한 날이었다. 두려움도 있지만 기대가 크다.',
    recordType: '이벤트',
    emotion: '설렘',
    category: '성장',
  ),
];
