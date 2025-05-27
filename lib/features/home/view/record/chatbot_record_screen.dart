// 🤖 챗봇 기록 화면
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../api/home_api.dart';
import '../../../auth/controller/auth_provider.dart';


class ChatbotRecordScreen extends ConsumerStatefulWidget {
  const ChatbotRecordScreen({super.key});





  @override
  ConsumerState<ChatbotRecordScreen> createState() => _PhotoRecordScreenState();
}

class _PhotoRecordScreenState extends ConsumerState<ChatbotRecordScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _friendController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emotionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _recordTypeController = TextEditingController();

  final _imagePicker = ImagePicker();
  List<XFile> _selectedImages = [];

  DateTime selectedDate = DateTime.now();



  @override
void initState() {
  super.initState();


}


  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images;
        });
      }
    } catch (e) {
      debugPrint('이미지 선택 중 오류 발생: $e');
    }
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

  if (_titleController.text.isEmpty ||
      _contentController.text.isEmpty ||
      _selectedImages.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('제목, 내용을 입력하고 이미지를 선택해주세요.')),
    );
    return;
  }

  final recordData = {
    'title': _titleController.text,
    'content': _contentController.text,
    'friend': _friendController.text,
    'location': _locationController.text,
    'emotion': _emotionController.text,
    'category': _categoryController.text,
    'recordType': _recordTypeController.text,
    'date': selectedDate.toIso8601String(),
    'type': 'photo',
  };

  debugPrint('[DEBUG] 📝 기록 데이터: $recordData');

  try {
    final success = await HomeApi.postRecord(userId, recordData, _selectedImages);
    debugPrint('[DEBUG] 📡 postRecord 결과: $success');

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기록이 저장되었습니다!')),
      );
      Navigator.of(context).pop(); // 저장 후 이전 화면으로 이동
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기록 저장에 실패했습니다.')),
      );
    }
  } catch (e) {
    debugPrint('[ERROR] 🧨 예외 발생: $e');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('기록 중 오류가 발생했어요.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 기록'),
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
            // 이미지 미리보기
            if (_selectedImages.isNotEmpty)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(
                        File(_selectedImages[index].path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            
            // 이미지 선택 버튼
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('이미지 선택'),
            ),
            const SizedBox(height: 16),

            // 제목
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 내용
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // 사람
            TextField(
              controller: _friendController,
              decoration: const InputDecoration(
                labelText: '함께한 사람',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 위치
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: '위치',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 감정
            TextField(
              controller: _emotionController,
              decoration: const InputDecoration(
                labelText: '감정',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 카테고리
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 기록 타입
            TextField(
              controller: _recordTypeController,
              decoration: const InputDecoration(
                labelText: '기록 타입',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 날짜 선택
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: '날짜',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

