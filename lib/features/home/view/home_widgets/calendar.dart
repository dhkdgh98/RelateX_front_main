
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum CalendarView { day, week, month, year }

class CalendarModal extends StatefulWidget {
  const CalendarModal({super.key});

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  CalendarView _currentView = CalendarView.day;
  DateTime _selectedDate = DateTime.now();
  bool _isRangeEnabled = false;

  void _goToPreviousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      print('이전 달로 이동: $_selectedDate');
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
      print('다음 달로 이동: $_selectedDate');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building CalendarModal: currentView=$_currentView, isRangeEnabled=$_isRangeEnabled');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isRangeEnabled = !_isRangeEnabled;
                      print('기간 활성화 상태 변경: $_isRangeEnabled');
                    });
                  },
                  icon: Icon(
                    _isRangeEnabled ? Icons.check_box : Icons.check_box_outline_blank,
                  ),
                  label: const Text('기간 활성화'),
                ),
                DropdownButton<CalendarView>(
                  value: _currentView,
                  underline: const SizedBox(),
                  onChanged: (CalendarView? newView) {
                    if (newView != null) {
                      setState(() {
                        _currentView = newView;
                        print('날짜 보기 변경: $_currentView');
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: CalendarView.day,
                      child: Text('일'),
                    ),
                    DropdownMenuItem(
                      value: CalendarView.week,
                      child: Text('주'),
                    ),
                    DropdownMenuItem(
                      value: CalendarView.month,
                      child: Text('월'),
                    ),
                    DropdownMenuItem(
                      value: CalendarView.year,
                      child: Text('년'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCalendarContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarContent() {
    print('Building calendar content for $_currentView');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _goToPreviousMonth,
            ),
            Text(
              DateFormat('yyyy년 M월').format(_selectedDate),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _goToNextMonth,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildCurrentView(),
      ],
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case CalendarView.day:
      case CalendarView.week:
        return _buildMonthCalendar();
      case CalendarView.month:
        return _buildMonthGrid();
      case CalendarView.year:
        return _buildYearGrid();
    }
  }

  Widget _buildMonthCalendar() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    print('Generating calendar for ${_selectedDate.year}-${_selectedDate.month}, $daysInMonth days');
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final day = firstDayOfMonth.add(Duration(days: index));
        return Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildMonthGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            '${index + 1}월',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildYearGrid() {
    final currentYear = _selectedDate.year;
    final startYear = currentYear - (currentYear % 10);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final year = startYear + index;
        return Center(
          child: Text(
            '$year년',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
} 