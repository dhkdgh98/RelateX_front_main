
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

  void _goToPrevious() {
    setState(() {
      if (_currentView == CalendarView.month) {
        _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month);
      } else if (_currentView == CalendarView.year) {
        _selectedDate = DateTime(_selectedDate.year - 10);
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      }
      print('이전 이동: $_selectedDate');
    });
  }

  void _goToNext() {
    setState(() {
      if (_currentView == CalendarView.month) {
        _selectedDate = DateTime(_selectedDate.year + 1, _selectedDate.month);
      } else if (_currentView == CalendarView.year) {
        _selectedDate = DateTime(_selectedDate.year + 10);
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
      }
      print('다음 이동: $_selectedDate');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building CalendarModal: currentView=$_currentView, isRangeEnabled=$_isRangeEnabled');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            _buildHeader(),
            const SizedBox(height: 8),
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
    );
  }

  

Widget _buildHeader() {
  return Row(
    mainAxisAlignment: _currentView == CalendarView.year
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.center,
    children: [
      IconButton(onPressed: _goToPrevious, icon: const Icon(Icons.chevron_left)),
      if (_currentView != CalendarView.year) const SizedBox(width: 8),
      if (_currentView != CalendarView.year)
        Text(
          _currentView == CalendarView.month
              ? '${_selectedDate.year}년'
              : DateFormat('yyyy년 M월').format(_selectedDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      else
        Text(
          () {
            final startYear = (_selectedDate.year ~/ 10) * 10;
            final endYear = startYear + 9;
            return '$startYear년 ~ $endYear년';
          }(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      if (_currentView != CalendarView.year) const SizedBox(width: 8),
      IconButton(onPressed: _goToNext, icon: const Icon(Icons.chevron_right)),
    ],
  );
}


  Widget _buildCalendarContent() {
    print('Building calendar content for $_currentView');
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
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final weekdayOffset = firstDayOfMonth.weekday % 7;

    final totalGridCount = weekdayOffset + daysInMonth;
    return GridView.builder(
      itemCount: totalGridCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemBuilder: (context, index) {
        if (index < weekdayOffset) {
          return const SizedBox.shrink();
        }
        final day = index - weekdayOffset + 1;
        return Center(
          child: Text('$day'),
        );
      },
    );
  }

  Widget _buildMonthGrid() {
    return GridView.builder(
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        final month = index + 1;
        return Center(
          child: Text('$month월'),
        );
      },
    );
  }

  Widget _buildYearGrid() {
    final startYear = (_selectedDate.year ~/ 10) * 10;
    return GridView.builder(
      itemCount: 10,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        final year = startYear + index;
        return Center(
          child: Text('$year년'),
        );
      },
    );
  }
}

