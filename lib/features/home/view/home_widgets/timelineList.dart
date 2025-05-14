

import 'package:flutter/material.dart';
import '../../model/home_model.dart'; // 👈 이걸로 불러오기

class TimelineListView extends StatelessWidget {
  final List<TimelineEntry>? entries;

  const TimelineListView({super.key, this.entries});

  @override
  Widget build(BuildContext context) {
    final isEmpty = entries == null || entries!.isEmpty;
    final data = isEmpty ? _mockEntries : entries!;
    data.sort((a, b) => b.date.compareTo(a.date)); // 최신순 정렬

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final entry = data[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 친구이름 + 제목
              Text(
                '${entry.friendName} · ${entry.title}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),

              // 📍 장소
              Text(
                entry.location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 12),

              // ✍️ 글 내용
              Text(
                entry.content,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              // 😊 감정, 🗂️ 카테고리, 💬 댓글, 📥 담기 버튼
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 왼쪽: 감정, 카테고리
                    Row(
                      children: [
                        Text('😊 ${entry.emotion}'),
                        const SizedBox(width: 12),
                        Text('🗂️ ${entry.category}'),
                      ],
                    ),

                    // 오른쪽: 댓글, 북마크
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 20),
                        const SizedBox(width: 12),
                        const Icon(Icons.bookmark_border, size: 20),
                      ],
                    ),
                  ],
                ),

              // ⏰ 날짜 (좌측 정렬)
              Text(
                '${entry.date.year}.${entry.date.month.toString().padLeft(2, '0')}.${entry.date.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 💾 목업 데이터
final List<TimelineEntry> _mockEntries = [
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
