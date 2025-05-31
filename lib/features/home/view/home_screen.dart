import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_widgets/recordBoxWidget.dart';
import 'home_widgets/timelineList.dart';
import '../model/home_provider.dart';
import '../model/timeline_model.dart';
import '../api/home_api.dart';
import 'home_widgets/chat_floating_button.dart';
import 'home_widgets/buttons.dart'; 
import '../../settings/view/setting_screen.dart';
import '../model/timeline_model.dart';

// 기록 화면들 임포트 (오빠가 만든 거 맞춰서 수정해줘~)
import 'record/photo_record_screen.dart';
import 'record/text_record_screen.dart';
import 'record/voice_record_screen.dart';
import 'record/chatbot_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool showRecordBox = true;
  Timer? _debounce;
  bool _isHandlingRecord = false;
  String _searchQuery = '';
  DateTime? _dateFilterStart;
  DateTime? _dateFilterEnd;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final currentPosition = _scrollController.offset;
      bool shouldShow = currentPosition <= 0;

      if (showRecordBox != shouldShow) {
        showRecordBox = shouldShow;

        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 100), () {
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleDateRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      _dateFilterStart = start;
      _dateFilterEnd = end;
    });
  }

  Future<void> _handleRecordTypeSelected(RecordType recordType) async {
    if (_isHandlingRecord) {
      debugPrint('[DEBUG] ⚠️ 이미 기록 처리 중입니다.');
      return;
    }

    _isHandlingRecord = true;
    debugPrint('[DEBUG] 📝 기록 화면 진입 - 타입: $recordType');

    try {
      bool? result;

      switch (recordType) {
        case RecordType.photo:
          result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PhotoRecordScreen()),
          );
          break;

        case RecordType.text:
          result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TextRecordScreen()),
          );
          break;

        case RecordType.voice:
          result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VoiceRecordScreen()),
          );
          break;

        case RecordType.chatbot:
          result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
          break;
      }

      debugPrint('[DEBUG] ✅ Navigator 결과: $result');

      if (result == true && mounted) {
        debugPrint('[DEBUG] 🔄 기록 완료됨! 타임라인 갱신할게~');
        ref.invalidate(homeProvider);
      } else {
        debugPrint('[DEBUG] ⏹ 기록 실패 또는 취소됨');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isHandlingRecord = false;
        });
      }
    }
  }

  void _handleEditEntry(TimelineEntry entry) {
    if (entry.id == null || entry.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('수정할 수 없는 기록입니다.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    // TODO: 수정 화면으로 이동
    debugPrint('[DEBUG] 📝 기록 수정 - ID: ${entry.id}');
  }

  Future<void> _handleDeleteEntry(TimelineEntry entry) async {
    if (entry.id == null || entry.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('삭제할 수 없는 기록입니다.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await HomeApi.deleteRecord(entry.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('기록이 삭제되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
        ref.invalidate(homeProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('기록 삭제 실패: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timelineAsync = ref.watch(homeProvider);

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: showRecordBox
                    ? Column(
                        key: const ValueKey("recordBox"),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Relate X',
                                  style: TextStyle(
                                    fontFamily: 'CourierPrime',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SettingScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          RecordBoxWidget(onRecordTypeSelected: _handleRecordTypeSelected),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: timelineAsync.when(
                  data: (entries) => ListView(
                    controller: _scrollController,
                    children: [
                      TimelineListView(
                        entries: entries,
                        searchQuery: _searchQuery,
                        dateFilterStart: _dateFilterStart,
                        dateFilterEnd: _dateFilterEnd,
                        onEdit: _handleEditEntry,
                        onDelete: _handleDeleteEntry,
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('오류가 발생했습니다: $error'),
                  ),
                ),
              ),
            ],
          ),

          if (showRecordBox)
            Positioned(
              bottom: 30,
              right: 20,
              child: AnimatedSlide(
                offset: Offset.zero,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: const ChatFloatingButton(),
              ),
            )
          else
            Buttons(
              onScrollToTop: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              onSearchChanged: _handleSearchChanged,
              onDateRangeSelected: _handleDateRangeSelected,
            ),
        ],
      ),
    );
  }
}
