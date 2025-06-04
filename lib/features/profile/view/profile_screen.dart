import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with TickerProviderStateMixin {
  late TabController _moduleTabController;

  @override
  void initState() {
    super.initState();
    _moduleTabController = TabController(length: 3, vsync: this); // 모듈 수에 맞게 조정
  }

  @override
  void dispose() {
    _moduleTabController.dispose();
    super.dispose();
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 상단 고정 헤더 (Explore 스타일)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              children: const [
                Icon(Icons.person, size: 28),
                SizedBox(width: 8),
                Text(
                  '나의 페이지',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 🔻 나머지는 스크롤 가능
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _sectionHeader(title: '나의 정보', onEdit: () {}),
                const SizedBox(height: 8),

                _roundedCard(
                  children: const [
                    _infoItem(title: '📌 최근 관심사   ', value: '심리학, AI, 관계 탐색'),
                    _infoItem(title: '👥 최근 만난 사람 ', value: '채린, 민수, 지혜'),
                    _infoItem(title: '🧠 나의 성향 레포트', value: 'INFJ, 불안형 애착'),
                    _infoItem(title: '📝 메타 데이터 요약', value: '감정: 섬세함, 주제: 관계 중심'),
                  ],
                ),

                const SizedBox(height: 32),
                _sectionHeader(title: '나의 모듈', onEdit: () {}),
                const SizedBox(height: 8),

                TabBar(
                  controller: _moduleTabController,
                  labelColor: Colors.black,
                  indicatorColor: Colors.deepPurple,
                  tabs: const [
                    Tab(text: '감정 분석'),
                    Tab(text: '애착 분석'),
                    Tab(text: 'CBT 인식'),
                  ],
                ),

                SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: _moduleTabController,
                    children: const [
                      Center(child: Text('감정 분석 결과 보여주기')),
                      Center(child: Text('애착 분석 결과 보여주기')),
                      Center(child: Text('CBT 인식 구조 보여주기')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



  Widget _sectionHeader({required String title, required VoidCallback onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: onEdit,
        ),
      ],
    );
  }

  Widget _roundedCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _infoItem extends StatelessWidget {
  final String title;
  final String value;

  const _infoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
