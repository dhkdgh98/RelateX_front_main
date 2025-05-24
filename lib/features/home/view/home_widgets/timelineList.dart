import 'package:flutter/material.dart';
import '../../model/home_model.dart';
import 'dart:convert';


class TimelineListView extends StatelessWidget {
  final List<TimelineEntry> entries;

  const TimelineListView({
    super.key,
    required this.entries,
  });

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
    // 디버그: entries 개수 확인
    print('TimelineListView - entries count: ${entries.length}');
    
    if (entries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '아직 기록이 없습니다.\n새로운 기록을 작성해보세요!',
            textAlign: TextAlign.center,
            style: TextStyle(
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
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        // 디버그: 각 entry 데이터 확인
        print('Entry $index: ${entry.title} - ${entry.content}');

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
                        // if (entry.imageUrl?.isNotEmpty ?? false)
                        //   Container(
                        //     width: 60,
                        //     height: 60,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8.0),
                        //       image: DecorationImage(
                        //         image: NetworkImage(entry.imageUrl!),
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),

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
