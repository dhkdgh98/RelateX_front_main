import 'package:flutter/material.dart';
import '../widgets/content_card.dart';

class ContentListScreen extends StatelessWidget {
  const ContentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contents = [
      {
        'title': '감정 일기 쓰는법',
        'description': '효과적인 감정 일기 작성 방법',
        'author': '심리학자 김민수',
        'readTime': '5분',
      },
      {
        'title': 'Relate X 활용 꿀팁',
        'description': '앱을 더 효과적으로 사용하는 방법',
        'author': 'Relate X 팀',
        'readTime': '3분',
      },
      {
        'title': '모듈 사용법',
        'description': '각 모듈의 특징과 활용법',
        'author': '전문가 이지은',
        'readTime': '7분',
      },
      {
        'title': '감정 관리의 기술',
        'description': '일상에서 실천하는 감정 관리법',
        'author': '심리상담사 박지원',
        'readTime': '6분',
      },
      {
        'title': '건강한 관계 맺기',
        'description': '더 나은 인간관계를 위한 가이드',
        'author': '관계 전문가 최유진',
        'readTime': '8분',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('컨텐츠'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: contents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final content = contents[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: 컨텐츠 상세 페이지로 이동
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content['title']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (content['description'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          content['description']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (content['author'] != null) ...[
                            Text(
                              content['author']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (content['readTime'] != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ],
                          if (content['readTime'] != null)
                            Text(
                              '${content['readTime']} 읽기',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 