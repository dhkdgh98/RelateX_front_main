

// import 'package:flutter/material.dart';
// import '../../model/home_model.dart'; // 👈 이걸로 불러오기

// class TimelineListView extends StatelessWidget {
//   final List<TimelineEntry>? entries;

//   const TimelineListView({super.key, this.entries});

//   @override
//   Widget build(BuildContext context) {
//     final isEmpty = entries == null || entries!.isEmpty;
//     final data = isEmpty ? _mockEntries : entries!;
//     data.sort((a, b) => b.date.compareTo(a.date)); // 최신순 정렬

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: data.length,
//       itemBuilder: (context, index) {
//         final entry = data[index];

//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(12.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 👤 친구이름 + 제목
//               Text(
//                 '${entry.friendName} · ${entry.title}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 4),

//               // 📍 장소
//               Text(
//                 entry.location,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // ✍️ 글 내용
//               Text(
//                 entry.content,
//                 style: const TextStyle(
//                   fontSize: 16,
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // 😊 감정, 🗂️ 카테고리, 💬 댓글, 📥 담기 버튼
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // 왼쪽: 감정, 카테고리
//                     Row(
//                       children: [
//                         Text('😊 ${entry.emotion}'),
//                         const SizedBox(width: 12),
//                         Text('🗂️ ${entry.category}'),
//                       ],
//                     ),

//                     // 오른쪽: 댓글, 북마크
//                     Row(
//                       children: [
//                         const Icon(Icons.comment, size: 20),
//                         const SizedBox(width: 12),
//                         const Icon(Icons.bookmark_border, size: 20),
//                       ],
//                     ),
//                   ],
//                 ),

//               // ⏰ 날짜 (좌측 정렬)
//               Text(
//                 '${entry.date.year}.${entry.date.month.toString().padLeft(2, '0')}.${entry.date.day.toString().padLeft(2, '0')}',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../model/home_model.dart';

class TimelineListView extends StatelessWidget {
  final List<TimelineEntry>? entries;

  const TimelineListView({
    super.key,
    this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final data = (entries == null || entries!.isEmpty) ? mockEntries : entries!;
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
              Text(
                '${entry.friendName} · ${entry.title}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                entry.location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                entry.content,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('😊 ${entry.emotion}'),
                      const SizedBox(width: 12),
                      Text('🗂️ ${entry.category}'),
                    ],
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
              const SizedBox(height: 8),
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
