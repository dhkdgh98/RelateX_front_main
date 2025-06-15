import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../api/home_api.dart';
import '../../../auth/controller/auth_provider.dart';
import '../../model/home_provider.dart';
import '../../../bottom_nav/view/bottom_nav_screen.dart';
import 'module_apply.dart';

class PhotoRecordScreen extends ConsumerStatefulWidget {
  const PhotoRecordScreen({super.key});

  @override
  ConsumerState<PhotoRecordScreen> createState() => _PhotoRecordScreenState();
}

class _PhotoRecordScreenState extends ConsumerState<PhotoRecordScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final _imagePicker = ImagePicker();
  List<XFile> _selectedImages = [];

  String? selectedFriend;
  String? selectedLocation;
  String? selectedEmotion;
  String? selectedCategory;
  String? selectedRecordType;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pickImages();
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

  Future<void> _showPickerModal({
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelected,
    required String category,
  }) async {
    final result = await showModalBottomSheet<String>(
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
            // 이미 선택된 옵션인지 확인
            final recordOptions = ref.read(recordOptionsProvider);
            if (recordOptions.hasValue) {
              final options = recordOptions.value!;
              if (options[category]!.contains(value)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이미 존재하는 옵션입니다.')),
                );
                return;
              }
            }
            Navigator.pop(context, value);
          },
          category: category,
        );
      },
    );

    if (result != null) {
      onSelected(result);
    }
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
            Expanded(
              child: Text(
                selectedValue ?? defaultLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
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

  if (_titleController.text.isEmpty ||
      _contentController.text.isEmpty ||
      _selectedImages.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('제목, 내용을 입력하고 이미지를 선택해주세요.')),
    );
    return;
  }

    // 선택된 옵션 저장
    final recordOptions = ref.read(recordOptionsProvider);
    if (recordOptions.hasValue) {
      final options = recordOptions.value!;
      try {
        if (selectedFriend != null && !options['friends']!.contains(selectedFriend)) {
          await HomeApi.addOption(userId, 'friends', selectedFriend!);
        }
        if (selectedLocation != null && !options['locations']!.contains(selectedLocation)) {
          await HomeApi.addOption(userId, 'locations', selectedLocation!);
        }
        if (selectedEmotion != null && !options['emotions']!.contains(selectedEmotion)) {
          await HomeApi.addOption(userId, 'emotions', selectedEmotion!);
        }
        if (selectedCategory != null && !options['categories']!.contains(selectedCategory)) {
          await HomeApi.addOption(userId, 'categories', selectedCategory!);
        }
        if (selectedRecordType != null && !options['recordTypes']!.contains(selectedRecordType)) {
          await HomeApi.addOption(userId, 'recordTypes', selectedRecordType!);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 존재하는 옵션입니다.')),
        );
        return;
      }
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
        ref.invalidate(homeProvider);
        ref.invalidate(recordOptionsProvider); // 옵션 목록 갱신
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
  }
}

  @override
  Widget build(BuildContext context) {
    final recordOptions = ref.watch(recordOptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 기록'),
        actions: [
          TextButton(
            onPressed: () {
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
                'friend': selectedFriend,
                'location': selectedLocation,
                'emotion': selectedEmotion,
                'category': selectedCategory,
                'recordType': selectedRecordType,
                'date': selectedDate.toIso8601String(),
                'type': 'photo',
              };

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleApplyScreen(
                    recordData: recordData,
                    images: _selectedImages,
                  ),
                ),
              );
            },
            child: const Text('다음'),
          ),
        ],
      ),
      body: recordOptions.when(
        data: (options) => SingleChildScrollView(
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
                  items: options['friends'] ?? [],
                  onSelected: (val) => setState(() => selectedFriend = val),
                  category: 'friends',
                ),
              ),

              _buildSelector(
                icon: Icons.location_on_outlined,
                selectedValue: selectedLocation,
                defaultLabel: '위치 추가',
                onTap: () => _showPickerModal(
                  title: '위치 선택',
                  items: options['locations'] ?? [],
                  onSelected: (val) => setState(() => selectedLocation = val),
                  category: 'locations',
                ),
              ),

              _buildSelector(
                icon: Icons.mood,
                selectedValue: selectedEmotion,
                defaultLabel: '감정 선택',
                onTap: () => _showPickerModal(
                  title: '감정 선택',
                  items: options['emotions'] ?? [],
                  onSelected: (val) => setState(() => selectedEmotion = val),
                  category: 'emotions',
                ),
              ),

              _buildSelector(
                icon: Icons.category_outlined,
                selectedValue: selectedCategory,
                defaultLabel: '카테고리 선택',
                onTap: () => _showPickerModal(
                  title: '카테고리 선택',
                  items: options['categories'] ?? [],
                  onSelected: (val) => setState(() => selectedCategory = val),
                  category: 'categories',
                ),
              ),

              _buildSelector(
                icon: Icons.label,
                selectedValue: selectedRecordType,
                defaultLabel: '기록 타입 선택',
                onTap: () => _showPickerModal(
                  title: '기록 타입',
                  items: options['recordTypes'] ?? [],
                  onSelected: (val) => setState(() => selectedRecordType = val),
                  category: 'recordTypes',
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
      ),
    );
  }
}

class _SearchablePickerModal extends StatefulWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final String category;

  const _SearchablePickerModal({
    required this.title,
    required this.items,
    required this.onSelected,
    required this.category,
  });

  @override
  State<_SearchablePickerModal> createState() => _SearchablePickerModalState();
}

class _SearchablePickerModalState extends State<_SearchablePickerModal> {
  final TextEditingController _customInputController = TextEditingController();
  String _searchQuery = '';
  List<String> _filteredItems = [];
  List<String> _newItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _handleCustomInput() {
    if (_customInputController.text.isNotEmpty) {
      // 중복 체크
      if (widget.items.contains(_customInputController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 존재하는 옵션입니다.')),
        );
        return;
      }
      setState(() {
        _newItems.add(_customInputController.text);
        _filteredItems.add(_customInputController.text);
      });
      _customInputController.clear();
    }
  }

  @override
  void dispose() {
    _customInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('${widget.title} 추가'),
                      content: TextField(
                        controller: _customInputController,
                        decoration: const InputDecoration(
                          hintText: '새로운 항목을 입력하세요',
                        ),
                        onSubmitted: (_) {
                          // 중복 체크
                          if (widget.items.contains(_customInputController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('이미 존재하는 옵션입니다.')),
                            );
                            return;
                          }
                          _handleCustomInput();
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            // 중복 체크
                            if (widget.items.contains(_customInputController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('이미 존재하는 옵션입니다.')),
                              );
                              return;
                            }
                            _handleCustomInput();
                            Navigator.pop(context);
                          },
                          child: const Text('추가'),
                        ),
                      ],
                    ),
                  );
                },
            ),
          ],
        ),
          const SizedBox(height: 16),
          TextField(
            controller: _customInputController,
            decoration: InputDecoration(
              hintText: '직접 입력하거나 검색하세요',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _customInputController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        // 중복 체크
                        if (widget.items.contains(_customInputController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('이미 존재하는 옵션입니다.')),
                          );
                          return;
                        }
                        _handleCustomInput();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _filterItems,
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isNew = _newItems.contains(item);
                return ListTile(
                  title: Text(item),
                  trailing: isNew ? const Icon(Icons.new_releases, color: Colors.blue) : null,
                  onTap: () => Navigator.pop(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
