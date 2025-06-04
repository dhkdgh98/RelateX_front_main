import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('커뮤니티'),
                    const SizedBox(height: 8),
                    _buildHorizontalCardList([
                      '공개 타임라인 1',
                      '공개 타임라인 2',
                      '공개 타임라인 3',
                    ]),

                    const SizedBox(height: 24),

                    _buildSectionHeader('모듈'),
                    const SizedBox(height: 8),
                    _buildHorizontalCardList([
                      '애착 분석',
                      '감정 분석',
                      'CBT 분석',
                    ]),

                    const SizedBox(height: 24),

                    _buildSectionHeader('컨텐츠'),
                    const SizedBox(height: 8),
                    _buildHorizontalCardList([
                      '감정 일기 쓰는법',
                      'Relate X 활용 꿀팁',
                      '모듈 사용법',
                    ]),
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
      child:Row(
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
            // TODO: 더보기 기능 구현
          },
          child: const Text('더보기'),
        ),
      ],
    ),
    );
    
  }

  /// 📦 좌우 스크롤 카드 리스트
  Widget _buildHorizontalCardList(List<String> items) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                items[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
