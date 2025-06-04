import 'package:flutter/material.dart';
import '../../model/timeline_model.dart';
import 'dart:convert';
import 'dart:math';

final _random = Random(); // 전역으로 Random 인스턴스 선언!



class TimelineListView extends StatelessWidget {
  final List<TimelineEntry> entries;
  final String searchQuery;
  final DateTime? dateFilterStart;
  final DateTime? dateFilterEnd;
  final Function(TimelineEntry) onEdit;
  final Function(TimelineEntry) onDelete;

  


  const TimelineListView({
    super.key,
    required this.entries,
    required this.onEdit,
    required this.onDelete,
    this.searchQuery = '',
    this.dateFilterStart,
    this.dateFilterEnd,

    
  });

  List<TimelineEntry> get filteredEntries {
    var filtered = entries;

    // 검색어 필터링
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((entry) {
        final title = entry.title.toLowerCase();
        final content = entry.content?.toLowerCase() ?? '';
        final friend = entry.friend.toLowerCase();
        final location = entry.location?.toLowerCase() ?? '';
        final emotion = entry.emotion?.toLowerCase() ?? '';
        final category = entry.category?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();

        return title.contains(query) ||
            content.contains(query) ||
            friend.contains(query) ||
            location.contains(query) ||
            emotion.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // 날짜 필터링
    if (dateFilterStart != null) {
      filtered = filtered.where((entry) {
        final entryDate = entry.date;
        if (dateFilterEnd != null) {
          // 기간 선택 모드
          final start = DateTime(dateFilterStart!.year, dateFilterStart!.month, dateFilterStart!.day);
          final end = DateTime(dateFilterEnd!.year, dateFilterEnd!.month, dateFilterEnd!.day);
          final entry = DateTime(entryDate.year, entryDate.month, entryDate.day);
          return !entry.isBefore(start) && !entry.isAfter(end);
        } else {
          // 단일 날짜 선택 모드
          return entryDate.year == dateFilterStart!.year &&
              entryDate.month == dateFilterStart!.month &&
              entryDate.day == dateFilterStart!.day;
        }
      }).toList();
    }

    return filtered;
  }





Widget buildTag(String text, {Color? color, bool useFixedColor = false}) {
  // 🎨 파스텔 톤 컬러 리스트
  final List<Color> tagColors = [
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
  ];

  // 💡 고정 색상 여부에 따라 색상 결정
  final Color tagColor = useFixedColor
      ? tagColors[text.hashCode % tagColors.length] // 텍스트 기반 고정 색상
      : color ?? tagColors[_random.nextInt(tagColors.length)]; // 랜덤 색상

  // 🏷️ 태그 위젯 생성
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
    decoration: BoxDecoration(
      color: tagColor,
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12.0, color: Colors.black87),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final filteredList = filteredEntries;
    print('TimelineListView - Total entries: ${entries.length}');
    print('TimelineListView - Filtered entries: ${filteredList.length}');
    print('TimelineListView - Search query: $searchQuery');
    print('TimelineListView - Date filter: $dateFilterStart to $dateFilterEnd');
    
    if (filteredList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            searchQuery.isEmpty && dateFilterStart == null
                ? '아직 기록이 없습니다.\n새로운 기록을 작성해보세요!'
                : searchQuery.isNotEmpty
                    ? '"$searchQuery"에 대한 검색 결과가 없습니다.'
                    : '선택한 날짜에 기록이 없습니다.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

return ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: filteredList.length,
  itemBuilder: (context, index) {
    final entry = filteredList[index];
    print('Filtered Entry $index: ${entry.title} - ${entry.content}');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 좌우
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 👑 수정된 부분: 친구 태그 + 장소 같은 줄에
                      if (entry.friend.isNotEmpty || (entry.location?.isNotEmpty ?? false))
                        Row(
                          children: [
                            if (entry.friend.isNotEmpty) buildTag(entry.friend),
                            if (entry.location?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  entry.location!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 20),
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit(entry);
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('기록 삭제'),
                                  content: const Text('이 기록을 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onDelete(entry);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('삭제'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('수정'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20),
                                  SizedBox(width: 8),
                                  Text('삭제'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if ((entry.imagesBase64?.isNotEmpty ?? false))
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(entry.imagesBase64!.first.split(',').last),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 본문 내용
            if (entry.content?.isNotEmpty ?? false) ...[
              Text(
                entry.content!,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],

            // 감정 & 카테고리 태그
            Row(
              children: [
                if (entry.emotion?.isNotEmpty ?? false)
                  buildTag(entry.emotion!),
                if (entry.category?.isNotEmpty ?? false)
                  buildTag(entry.category!),
              ],
            ),
            const SizedBox(height: 12),

            // 댓글/북마크 아이콘 + 날짜
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${entry.date.year}.${entry.date.month.toString().padLeft(2, '0')}.${entry.date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);
  }
}