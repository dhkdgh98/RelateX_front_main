import 'package:flutter/material.dart';
import 'home_widgets/recordBoxWidget.dart';
import 'home_widgets/weekCalendar.dart';
import 'home_widgets/timelineList.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool showRecordBox = true;
  double lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final currentPosition = _scrollController.offset;
      final isScrollingUp = currentPosition < lastScrollPosition;
      
      setState(() {
        if (currentPosition <= 0) {
          // 최상단에서는 RecordBox 표시
          showRecordBox = true;
        } else if (isScrollingUp) {
          // 위로 스크롤하면 WeekCalendar 표시
          showRecordBox = false;
        } else if (!isScrollingUp && currentPosition > 100) {
          // 아래로 스크롤하고 위치가 100 초과일 때 RecordBox 표시
          showRecordBox = true;
        }
      });
      
      lastScrollPosition = currentPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showRecordBox
                  ? const RecordBoxWidget()
                  : const WeekCalendarHeader(),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: const [
                  TimelineListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
