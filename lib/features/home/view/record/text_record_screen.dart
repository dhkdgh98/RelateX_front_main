import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/home_api.dart';
import '../../../auth/controller/auth_provider.dart';
import '../../model/home_provider.dart';
import '../../../bottom_nav/view/bottom_nav_screen.dart';


class TextRecordScreen extends ConsumerStatefulWidget {
  const TextRecordScreen({super.key});

  @override
  ConsumerState<TextRecordScreen> createState() => _TextRecordScreenState();
}


class _TextRecordScreenState extends ConsumerState<TextRecordScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  
  String? selectedFriend;
  String? selectedLocation;
  String? selectedEmotion;
  String? selectedCategory;
  String? selectedRecordType;
  DateTime selectedDate = DateTime.now();

  final List<String> _friends = ['나','채린', '민수', '지민'];
  final List<String> _locations = ['카페', '공원', '도서관', '자취방','학교', '영화관'];
  final List<String> _emotions = ['행복', '불안', '설렘', '차분함', '자신감'];
  final List<String> _categories = ['일상', '성장', '자기성찰'];
  final List<String> _recordTypes = ['이벤트', '생각', '대화'];




  Future<void> _showPickerModal({
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _SearchablePickerModal(
          title: title,
          items: items,
          onSelected: (value) {
            onSelected(value);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildSelector({
    required IconData icon,
    required String? selectedValue,
    required String defaultLabel,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              selectedValue ?? defaultLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }






Future<void> _submitRecord() async {
  final userId = ref.read(authProvider).userId;
  debugPrint('[DEBUG] 👤 유저 ID: $userId');

  if (userId == null) {
    if (!mounted) return;
    debugPrint('[DEBUG] ❌ 유저 ID 없음. 로그인 필요!');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그인이 필요합니다.')),
    );
    return;
  }

  final recordData = {
    'title': _titleController.text,
    'content': _contentController.text,
    'friend': selectedFriend,
    'location': selectedLocation,
    'emotion': selectedEmotion,
    'category': selectedCategory,
    'recordType': selectedRecordType,
    'date': selectedDate.toIso8601String(),
  };

  debugPrint('[DEBUG] 📝 기록 데이터: $recordData');

  try {
    final success = await HomeApi.postRecord(userId, recordData);
    debugPrint('[DEBUG] 📡 postRecord 결과: $success');

    if (!mounted) {
      debugPrint('[DEBUG] ❗ context unmouted. 화면이 사라짐.');
      return;
    }

    if (success) {
      debugPrint('[DEBUG] ✅ 기록 저장 성공! 홈화면으로 이동합니다.');
      if (mounted) {
        ref.invalidate(homeProvider);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),
          (route) => false,
        );
      }
    } else {
      debugPrint('[DEBUG] ❌ 기록 저장 실패');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기록 저장에 실패했습니다.')),
      );
    }
  } catch (e, stack) {
    debugPrint('[ERROR] 🧨 예외 발생: $e\n$stack');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('오류가 발생했습니다: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('텍스트 기록'),
        actions: [
          TextButton(
            onPressed: _submitRecord,
            child: const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            _buildSelector(
              icon: Icons.person_add_alt_1,
              selectedValue: selectedFriend,
              defaultLabel: '사람 추가',
              onTap: () => _showPickerModal(
                title: '관계 선택',
                items: _friends,
                onSelected: (val) => setState(() => selectedFriend = val),
              ),
            ),

            _buildSelector(
              icon: Icons.location_on_outlined,
              selectedValue: selectedLocation,
              defaultLabel: '위치 추가',
              onTap: () => _showPickerModal(
                title: '위치 선택',
                items: _locations,
                onSelected: (val) => setState(() => selectedLocation = val),
              ),
            ),

            _buildSelector(
              icon: Icons.mood,
              selectedValue: selectedEmotion,
              defaultLabel: '감정 선택',
              onTap: () => _showPickerModal(
                title: '감정 선택',
                items: _emotions,
                onSelected: (val) => setState(() => selectedEmotion = val),
              ),
            ),

            _buildSelector(
              icon: Icons.category_outlined,
              selectedValue: selectedCategory,
              defaultLabel: '카테고리 선택',
              onTap: () => _showPickerModal(
                title: '카테고리 선택',
                items: _categories,
                onSelected: (val) => setState(() => selectedCategory = val),
              ),
            ),

            _buildSelector(
              icon: Icons.label,
              selectedValue: selectedRecordType,
              defaultLabel: '기록 타입 선택',
              onTap: () => _showPickerModal(
                title: '기록 타입',
                items: _recordTypes,
                onSelected: (val) => setState(() => selectedRecordType = val),
              ),
            ),

            const SizedBox(height: 12),
            _buildSelector(
              icon: Icons.calendar_today,
              selectedValue:
                  '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
              defaultLabel: '날짜 선택',
              onTap: _selectDate,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchablePickerModal extends StatelessWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String> onSelected;

  const _SearchablePickerModal({
    required this.title,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  onTap: () => onSelected(items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
