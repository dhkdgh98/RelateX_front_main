import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../api/home_api.dart';
import '../../../auth/controller/auth_provider.dart';
import '../../model/home_provider.dart';
import '../../../bottom_nav/view/bottom_nav_screen.dart';

class ModuleApplyScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> recordData;
  final List<XFile>? images;

  const ModuleApplyScreen({
    super.key,
    required this.recordData,
    this.images,
  });

  @override
  ConsumerState<ModuleApplyScreen> createState() => _ModuleApplyScreenState();
}

class _ModuleApplyScreenState extends ConsumerState<ModuleApplyScreen> {
  bool _isLoading = false;

  Future<void> _submitRecord() async {
    setState(() => _isLoading = true);

    final userId = ref.read(authProvider).userId;
    debugPrint('[DEBUG] 👤 유저 ID: $userId');

    if (userId == null) {
      if (!mounted) return;
      debugPrint('[DEBUG] ❌ 유저 ID 없음. 로그인 필요!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final success = await HomeApi.postRecord(
        userId,
        widget.recordData,
        widget.images,
      );
      debugPrint('[DEBUG] 📡 postRecord 결과: $success');

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('기록이 저장되었습니다!')),
        );
        ref.invalidate(homeProvider);
        ref.invalidate(recordOptionsProvider);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),
          (route) => false,
        );
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기록 확인'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitRecord,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이미지 미리보기
            if (widget.images != null && widget.images!.isNotEmpty)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(
                        File(widget.images![index].path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

            // 기록 데이터 표시
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '제목: ${widget.recordData['title']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('내용: ${widget.recordData['content']}'),
                    if (widget.recordData['friend'] != null) ...[
                      const SizedBox(height: 8),
                      Text('함께한 사람: ${widget.recordData['friend']}'),
                    ],
                    if (widget.recordData['location'] != null) ...[
                      const SizedBox(height: 8),
                      Text('위치: ${widget.recordData['location']}'),
                    ],
                    if (widget.recordData['emotion'] != null) ...[
                      const SizedBox(height: 8),
                      Text('감정: ${widget.recordData['emotion']}'),
                    ],
                    if (widget.recordData['category'] != null) ...[
                      const SizedBox(height: 8),
                      Text('카테고리: ${widget.recordData['category']}'),
                    ],
                    if (widget.recordData['recordType'] != null) ...[
                      const SizedBox(height: 8),
                      Text('기록 타입: ${widget.recordData['recordType']}'),
                    ],
                    const SizedBox(height: 8),
                    Text('날짜: ${widget.recordData['date']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 