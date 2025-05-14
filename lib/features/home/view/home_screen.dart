
import 'dart:async';
import 'package:flutter/material.dart';
import 'home_widgets/recordBoxWidget.dart';
import 'home_widgets/timelineList.dart';
import '../model/home_model.dart';

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
    entries.sort((a, b) => b.date.compareTo(a.date)); // 최근 날짜 순으로 정렬

    _scrollController.addListener(() {
      final currentPosition = _scrollController.offset;
      bool shouldShow = currentPosition <= 0;

      // 상태 변경이 있을 때만 setState 호출
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
    _scrollController.dispose(); // 컨트롤러도 꼭 dispose 해줘야 메모리 누수 방지해!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      RecordBoxWidget(),
                    ],
                  )
                : const SizedBox.shrink(), // 빈 위젯
          ),
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
    );
  }
}
