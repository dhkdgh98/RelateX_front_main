import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionAnalysisScreen extends ConsumerStatefulWidget {
  const EmotionAnalysisScreen({super.key});

  @override
  ConsumerState<EmotionAnalysisScreen> createState() => _EmotionAnalysisScreenState();
}

class _EmotionAnalysisScreenState extends ConsumerState<EmotionAnalysisScreen> {
  final List<String> emotions = [
    '행복', '슬픔', '분노', '불안', '평온', '기쁨', '우울', '스트레스'
  ];

  String? selectedEmotion;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('감정 분석'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 오늘의 감정 선택
            const Text(
              '오늘의 감정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: emotions.map((emotion) {
                final isSelected = emotion == selectedEmotion;
                return ChoiceChip(
                  label: Text(emotion),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedEmotion = selected ? emotion : null;
                    });
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Colors.purple.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.purple.shade700 : Colors.black87,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // 감정 강도
            const Text(
              '감정 강도',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Slider(
              value: 5,
              min: 1,
              max: 10,
              divisions: 9,
              label: '5',
              onChanged: (value) {
                // TODO: 감정 강도 저장
              },
            ),
            
            const SizedBox(height: 24),
            
            // 메모
            const Text(
              '메모',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '오늘의 감정에 대해 기록해보세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 감정 패턴 분석
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '감정 패턴 분석',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TODO: 차트 위젯 추가
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('감정 패턴 차트가 여기에 표시됩니다'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // TODO: 감정 기록 저장
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '기록하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 