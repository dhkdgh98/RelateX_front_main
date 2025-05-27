import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_widgets/recordBoxWidget.dart';
import 'home_widgets/timelineList.dart';
import '../model/home_provider.dart';
import 'home_widgets/chat_floating_button.dart';
import 'home_widgets/buttons.dart'; 
import '../../settings/view/setting_screen.dart';

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
                      TimelineListView(entries: entries),
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
            ),
        ],
      ),
    );
  }
}
