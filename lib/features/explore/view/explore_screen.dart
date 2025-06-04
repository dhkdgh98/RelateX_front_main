import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/community_card.dart';
import '../widgets/module_card.dart';
import '../widgets/content_card.dart';
import 'community_list_screen.dart';
import 'module_list_screen.dart';
import 'content_list_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 상단 고정 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: const [
                  Icon(Icons.explore, size: 28),
                  SizedBox(width: 8),
                  Text(
                    '탐색',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 나머지 스크롤 가능한 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('커뮤니티'),
                    const SizedBox(height: 16),
                    _buildCommunityList(),

                    const SizedBox(height: 32),

                    _buildSectionHeader('모듈'),
                    const SizedBox(height: 16),
                    _buildModuleList(),

                    const SizedBox(height: 32),

                    _buildSectionHeader('컨텐츠'),
                    const SizedBox(height: 16),
                    _buildContentList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧩 섹션 헤더: 타이틀 + 더보기 버튼
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () {
              switch (title) {
                case '커뮤니티':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityListScreen(),
                    ),
                  );
                  break;
                case '모듈':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ModuleListScreen(),
                    ),
                  );
                  break;
                case '컨텐츠':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContentListScreen(),
                    ),
                  );
                  break;
              }
            },
            child: const Text('더보기'),
          ),
        ],
      ),
    );
  }

  /// 📦 커뮤니티 카드 리스트
  Widget _buildCommunityList() {
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
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: communities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
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

  /// 📦 모듈 카드 리스트
  Widget _buildModuleList() {
    final modules = [
      {
        'title': '애착 분석',
        'description': '당신의 애착 유형을 분석해보세요',
        'icon': Icons.psychology,
      },
      {
        'title': '감정 분석',
        'description': '감정 패턴을 파악하고 관리하세요',
        'icon': Icons.mood,
      },
      {
        'title': 'CBT 분석',
        'description': '인지행동치료 기반 분석',
        'icon': Icons.psychology_alt,
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final module = modules[index];
          return ModuleCard(
            title: module['title'] as String,
            description: module['description'] as String?,
            icon: module['icon'] as IconData,
            onTap: () {
              // TODO: 모듈 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }

  /// 📦 컨텐츠 카드 리스트
  Widget _buildContentList() {
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
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: contents.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final content = contents[index];
          return ContentCard(
            title: content['title']!,
            description: content['description'],
            author: content['author'],
            readTime: content['readTime'],
            onTap: () {
              // TODO: 컨텐츠 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }
}
