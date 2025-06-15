import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import '../../api/home_api.dart';
import '../../../auth/controller/auth_provider.dart';
import '../../model/home_provider.dart';
import '../../../bottom_nav/view/bottom_nav_screen.dart';
import '../module_select/ghibli_module.dart';

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
  List<String> _selectedModules = [];
  bool _isGeneratingImage = false;
  String? _generatedImageUrl;
  List<XFile> _allImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.images != null) {
      _allImages = List.from(widget.images!);
    }
  }

  Future<void> _showModuleSelectionModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '모듈 추가',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GhibliModule.buildModuleTile(
              selectedModules: _selectedModules,
              onModuleSelected: (value) {
                if (value != null) {
                  setState(() {
                    if (_selectedModules.contains(value)) {
                      _selectedModules.remove(value);
                    } else {
                      _selectedModules.add(value);
                    }
                  });
                  Navigator.pop(context);
                  _showModuleSettingsModal(value);
                }
              },
              generatedImageUrl: _generatedImageUrl,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showModuleSettingsModal(String moduleId) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '모듈 설정',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                    _showModuleSelectionModal();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (moduleId == GhibliModule.moduleId)
              GhibliModule.buildModuleSettings(
                generatedImageUrl: _generatedImageUrl,
                isGeneratingImage: _isGeneratingImage,
                onGenerateImage: _generateImage,
                onConfirm: () {
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  // Base64 이미지를 File로 변환하는 함수
  Future<XFile?> _convertBase64ToFile(String base64String) async {
    try {
      // Base64 문자열에서 실제 데이터 부분만 추출
      final base64Data = base64String.split(',')[1];
      final bytes = base64Decode(base64Data);
      
      // 임시 디렉토리에 파일 저장
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/ghibli_image_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      
      return XFile(file.path);
    } catch (e) {
      debugPrint('Base64 변환 중 오류 발생: $e');
      return null;
    }
  }

  Future<void> _generateImage() async {
    setState(() => _isGeneratingImage = true);

    try {
      final imageData = await GhibliModule.generateImage(
        widget.recordData['content'],
        ref,
      );

      if (!mounted) return;

      if (imageData != null) {
        setState(() => _generatedImageUrl = imageData);
        
        // Base64 이미지를 File로 변환
        final imageFile = await _convertBase64ToFile(imageData);
        if (imageFile != null) {
          setState(() {
            _allImages.add(imageFile);
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지가 생성되었습니다!')),
        );
        Navigator.pop(context); // 현재 모달 닫기
        _showModuleSettingsModal(GhibliModule.moduleId); // 새로운 모달 열기
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지 생성에 실패했습니다.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 생성 중 오류가 발생했습니다: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isGeneratingImage = false);
      }
    }
  }

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
      final recordData = {
        ...widget.recordData,
        if (_selectedModules.isNotEmpty) 'modules': _selectedModules,
      };

      final success = await HomeApi.postRecord(
        userId,
        recordData,
        _allImages, // 모든 이미지 포함
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
            // 모듈 선택
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '모듈',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _showModuleSelectionModal();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('모듈 추가하기'),
                        ),
                      ],
                    ),
                    if (_selectedModules.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ..._selectedModules.map((moduleId) {
                        if (moduleId == GhibliModule.moduleId) {
                          return GhibliModule.buildModuleTile(
                            selectedModules: _selectedModules,
                            onModuleSelected: (value) {
                              _showModuleSelectionModal();
                            },
                            generatedImageUrl: _generatedImageUrl,
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 이미지 미리보기
            if (_allImages.isNotEmpty)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _allImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(
                        File(_allImages[index].path),
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