import 'package:flutter/material.dart';
import '../../model/timeline_model.dart';
import 'dart:convert';


class TimelineListView extends StatelessWidget {
  final List<TimelineEntry> entries;
  final String searchQuery;
  final DateTime? dateFilterStart;
  final DateTime? dateFilterEnd;

  const TimelineListView({
    super.key,
    required this.entries,
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

  Widget buildTag(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (entry.friend.isNotEmpty)
                            buildTag(entry.friend),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (entry.location?.isNotEmpty ?? false)
                          Text(
                            entry.location!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
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
                    style: const TextStyle(fontSize: 15),
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
                    Row(
                      children: const [
                        Icon(Icons.comment, size: 20),
                        SizedBox(width: 12),
                        Icon(Icons.bookmark_border, size: 20),
                      ],
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
