import 'package:flutter/material.dart';
import 'home_widgets/recordBoxWidget.dart';
import 'home_widgets/weekCalendar.dart';
import 'home_widgets/timelineList.dart';

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
          // �� ���� ��ũ�� �Ǿ��� �� RecordBox ǥ��
          showRecordBox = true;
        } else if (isScrollingUp) {
          // ���� ��ũ���ϸ� WeekCalendar ǥ��
          showRecordBox = false;
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
