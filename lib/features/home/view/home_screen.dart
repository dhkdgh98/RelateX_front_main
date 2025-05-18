
import 'dart:async';
import 'package:flutter/material.dart';
import 'home_widgets/recordBoxWidget.dart';
import 'home_widgets/timelineList.dart';
import '../model/home_model.dart';
import 'home_widgets/chat_floating_button.dart';
import 'home_widgets/buttons.dart'; // ✅ 버튼 묶음 위젯!

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool showRecordBox = true;
  late List<TimelineEntry> entries;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    entries = mockEntries;
    entries.sort((a, b) => b.date.compareTo(a.date));

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              // ✅ 위쪽 record 박스 영역 (스크롤 시 사라짐)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: showRecordBox
                    ? Column(
                        key: const ValueKey("recordBox"),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: Text(
                              'Relate X',
                              style: TextStyle(
                                fontFamily: 'CourierPrime',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,  // 이 부분 추가
                                fontStyle: FontStyle.normal,   // 이 부분 추가
                                color: Colors.black,
                              ),
                            ),
                          ),
                          RecordBoxWidget(),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              // ✅ 타임라인 리스트
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    TimelineListView(entries: entries),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ✅ showRecordBox가 true일 때 챗봇 버튼 보이고,
        // false일 땐 버튼 묶음 보여주기!
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
    );
  }
}
