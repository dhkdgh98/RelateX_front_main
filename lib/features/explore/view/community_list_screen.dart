import 'package:flutter/material.dart';
import '../widgets/community_card.dart';

class CommunityListScreen extends StatelessWidget {
  const CommunityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final communities = [
      {
        'title': '일상',
        'description': '일상의 순간을 공유하는 공간',
        'memberCount': '1.2k',
      },
      {
        'title': '감정',
        'description': '감정을 나누는 커뮤니티',
        'memberCount': '856',
      },
      {
        'title': '힐링',
        'description': '힐링과 위로의 공간',
        'memberCount': '2.3k',
      },
      {
        'title': '성장',
        'description': '함께 성장하는 공간',
        'memberCount': '1.5k',
      },
      {
        'title': '관계',
        'description': '인간관계에 대해 이야기하는 공간',
        'memberCount': '2.1k',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: communities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final community = communities[index];
          return CommunityCard(
            title: community['title']!,
            description: community['description'],
            memberCount: community['memberCount'],
            onTap: () {
              // TODO: 커뮤니티 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }
} 