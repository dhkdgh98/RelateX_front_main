
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
          // �� ���� ��ũ�� �Ǿ��� �� �ٽ� �����ֱ�
          showRecordBox = true;
        } else if (isScrollingUp) {
          // ���� ��ũ���ϸ� �����
          showRecordBox = false;
        }
      });

      lastScrollPosition = currentPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  : const WeekCalendarHeader(
                      key: ValueKey("weekCalendar"),
                    ),
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
