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

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      date: DateTime.parse(json['date']),
      friendName: json['friendName'],
      title: json['title'],
      location: json['location'],
      content: json['content'],
      emotion: json['emotion'],
      category: json['category'],
    );
  }
}

final List<TimelineEntry> mockEntries = [
  TimelineEntry(
    date: DateTime(2025, 4, 28),
    friendName: '태훈',
    title: '불안한 마음',
    location: '카페거리',
    content: '오늘은 불안함을 느끼며, 이를 받아들이려고 노력했다.',
    emotion: '불안',
    category: '자기성찰',
  ),
  TimelineEntry(
    date: DateTime(2025, 3, 15),
    friendName: '영호',
    title: '긍정적인 변화',
    location: '도서관',
    content: '새로운 시작을 위해 다짐하며 공부했다.',
    emotion: '자신감',
    category: '성장',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 10),
    friendName: '나 자신',
    title: '자기반성',
    location: '내 방',
    content: '하루를 되돌아보며 감정 정리를 했다. 나 자신에게 솔직해지는 연습을 하고 있다.',
    emotion: '차분함',
    category: '자기성찰',
  ),
  TimelineEntry(
    date: DateTime(2025, 5, 2),
    friendName: '세정',
    title: '새로운 시작',
    location: '공원',
    content: '새로운 도전을 시작한 날이었다. 두려움도 있지만 기대가 크다.',
    emotion: '설렘',
    category: '성장',
  ),
  TimelineEntry(
    date: DateTime(2025, 3, 30),
    friendName: '윤아',
    title: '과거의 기억',
    location: '집',
    content: '오랜만에 과거의 사진을 보며 추억에 잠겼다.',
    emotion: '슬픔',
    category: '관계',
  ),
  TimelineEntry(
    date: DateTime(2025, 5, 10),
    friendName: '지민',
    title: '용기 내기',
    location: '지하철',
    content: '오랜만에 용기를 내어 새로운 사람에게 말을 걸었다.',
    emotion: '기쁨',
    category: '목표',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 25),
    friendName: '하늘',
    title: '조용한 하루',
    location: '커피숍',
    content: '혼자 커피를 마시며 생각을 정리한 날이었다.',
    emotion: '평온',
    category: '마음관리',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 5),
    friendName: '수현',
    title: '소소한 행복',
    location: '카카톡',
    content: '친구와 오랜만에 연락을 하며 기분 좋은 시간을 보냈다.',
    emotion: '기쁨',
    category: '관계',
  ),
  TimelineEntry(
    date: DateTime(2025, 3, 18),
    friendName: '영호',
    title: '내일을 위한 준비',
    location: '도서관',
    content: '내일의 계획을 세우며 준비를 시작했다.',
    emotion: '자신감',
    category: '목표',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 13),
    friendName: '혼자',
    title: '긍정적인 변화',
    location: '집',
    content: '스스로의 긍정적인 변화에 대한 마음을 다잡았다.',
    emotion: '기쁨',
    category: '성장',
  ),
  TimelineEntry(
    date: DateTime(2025, 3, 22),
    friendName: '나 자신',
    title: '불안한 마음',
    location: '카페거리',
    content: '불안함을 느끼며 혼자 감정을 정리한 하루였다.',
    emotion: '불안',
    category: '자기성찰',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 18),
    friendName: '지민',
    title: '소소한 행복',
    location: '공원',
    content: '작은 일에서 행복을 찾은 날이었다.',
    emotion: '평온',
    category: '마음관리',
  ),
  TimelineEntry(
    date: DateTime(2025, 3, 17),
    friendName: '민지',
    title: '진심을 담은 대화',
    location: '카카오톡',
    content: '오늘은 민지랑 오랜만에 연락했다. 예전의 나처럼 행동하지 않고 진심을 담아 대화하려고 노력한 날이었다.',
    emotion: '감동',
    category: '관계',
  ),
  TimelineEntry(
    date: DateTime(2025, 5, 8),
    friendName: '태훈',
    title: '새로운 시작',
    location: '학원',
    content: '학원에서 새로운 친구를 만났다.',
    emotion: '설렘',
    category: '성장',
  ),
  TimelineEntry(
    date: DateTime(2025, 5, 3),
    friendName: '영호',
    title: '조용한 하루',
    location: '카페거리',
    content: '혼자만의 시간을 가지며 마음을 가다듬었다.',
    emotion: '평온',
    category: '마음관리',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 2),
    friendName: '수현',
    title: '자기반성',
    location: '도서관',
    content: '하루를 마무리하며 자신의 행동을 돌아보았다.',
    emotion: '차분함',
    category: '자기성찰',
  ),
  TimelineEntry(
    date: DateTime(2025, 3, 25),
    friendName: '세정',
    title: '긍정적인 변화',
    location: '커피숍',
    content: '긍정적인 마음을 다잡고 새로운 목표를 세웠다.',
    emotion: '자신감',
    category: '성장',
  ),
  TimelineEntry(
    date: DateTime(2025, 4, 20),
    friendName: '하늘',
    title: '과거의 기억',
    location: '집',
    content: '과거를 돌아보며 많은 생각을 했다.',
    emotion: '슬픔',
    category: '관계',
  ),
];
