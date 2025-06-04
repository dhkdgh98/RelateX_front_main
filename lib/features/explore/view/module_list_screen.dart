import 'package:flutter/material.dart';
import '../widgets/module_card.dart';

class ModuleListScreen extends StatelessWidget {
  const ModuleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      {
        'title': '성격 분석',
        'description': 'MBTI 기반 성격 분석',
        'icon': Icons.person,
      },
      {
        'title': '관계 분석',
        'description': '인간관계 패턴 분석',
        'icon': Icons.people,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('모듈'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
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
} 