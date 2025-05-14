
import 'package:flutter/material.dart';
import 'home_widgets/recordBoxWidget.dart';
import 'home_widgets/weekCalendar.dart';
import 'home_widgets/timelineList.dart';
import '../model/home_model.dart'; // 👈 entries 모델을 불러오기

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool showRecordBox = true;
  double lastScrollPosition = 0;

  DateTime selectedDate = DateTime.now();
  late List<TimelineEntry> entries;

  @override
  void initState() {
    super.initState();

    entries = mockEntries; // 나중에 서버 연동 시 entries 바꿔주면 돼
    entries.sort((a, b) => b.date.compareTo(a.date));

    if (entries.isNotEmpty) {
      selectedDate = entries.first.date;
    }

    _scrollController.addListener(() {
      final currentPosition = _scrollController.offset;
      final isScrollingUp = currentPosition < lastScrollPosition;

      // 가장 위에 있는 항목을 기준으로 selectedDate 갱신
      if (_scrollController.position.pixels == 0) {
        setState(() {
          selectedDate = entries.first.date; // 리스트 맨 위로 스크롤될 때
        });
      } else {
        final index = (_scrollController.offset / 100).floor(); // 항목 간격에 맞춰서 선택된 날짜 찾기
        setState(() {
          selectedDate = entries[index].date;
        });
      }

      setState(() {
        if (currentPosition <= 0) {
          showRecordBox = true;
        } else if (isScrollingUp) {
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
                  : WeekCalendarHeader(
                      key: const ValueKey("weekCalendar"),
                      selectedDate: selectedDate,
                      onDateSelected: (newDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                    ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  TimelineListView(
                    entries: entries,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
