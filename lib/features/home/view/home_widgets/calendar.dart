

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

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void _goToPrevious() {
    setState(() {
      if (_currentView == CalendarView.month) {
        _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month);
      } else if (_currentView == CalendarView.year) {
        _selectedDate = DateTime(_selectedDate.year - 10);
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      }
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
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      if (_isRangeEnabled) {
        if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
          _rangeStart = date;
          _rangeEnd = null;
        } else {
          if (date.isBefore(_rangeStart!)) {
            _rangeEnd = _rangeStart;
            _rangeStart = date;
          } else {
            _rangeEnd = date;
          }
        }
      } else {
        _selectedDate = date;
      }
    });
  }

  bool _isDateSelected(DateTime date) {
  if (_isRangeEnabled && _rangeStart != null && _rangeEnd != null) {
    // 시작일과 종료일 '포함'해서 체크
    return !date.isBefore(_rangeStart!) && !date.isAfter(_rangeEnd!);
  } else {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 상단 컨트롤
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isRangeEnabled = !_isRangeEnabled;
                    });
                  },
                  icon: Icon(
                    _isRangeEnabled ? Icons.check_box : Icons.check_box_outline_blank,
                  ),
                  label: const Text('기간 선택'),
                ),
                DropdownButton<CalendarView>(
                  value: _currentView,
                  underline: const SizedBox(),
                  onChanged: (CalendarView? newView) {
                    if (newView != null) {
                      setState(() {
                        _currentView = newView;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: CalendarView.day, child: Text('일')),
                    DropdownMenuItem(value: CalendarView.week, child: Text('주')),
                    DropdownMenuItem(value: CalendarView.month, child: Text('월')),
                    DropdownMenuItem(value: CalendarView.year, child: Text('년')),
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
      if (index < weekdayOffset) return const SizedBox.shrink();

      final day = index - weekdayOffset + 1;
      final currentDate = DateTime(_selectedDate.year, _selectedDate.month, day);

      bool isRangeSelected = false;

      if (_rangeStart != null && _rangeEnd != null) {
        // 시작일과 종료일 모두 선택되었을 때 범위 전체 강조
        isRangeSelected = !currentDate.isBefore(_rangeStart!) && !currentDate.isAfter(_rangeEnd!);
      } else if (_rangeStart != null && _rangeEnd == null) {
        // 시작일만 선택됐을 때는 시작일만 강조
        isRangeSelected = currentDate == _rangeStart;
      }

      final isSingleSelected = !_isRangeEnabled &&
          currentDate.year == _selectedDate.year &&
          currentDate.month == _selectedDate.month &&
          currentDate.day == _selectedDate.day;

      return GestureDetector(
        onTap: () => _onDateSelected(currentDate),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            // color: isRangeSelected || isSingleSelected
            //     ? Colors.blue
            //     : null,
            color: isRangeSelected || isSingleSelected
    ? Colors.grey.withOpacity(0.3)  // 여기 밝은 회색에 투명도 0.3으로 바꿨어~
    : null,

            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: TextStyle(
              color: isRangeSelected || isSingleSelected ? Colors.black : null,
              fontWeight: isRangeSelected || isSingleSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
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
        final currentDate = DateTime(_selectedDate.year, month);
        return GestureDetector(
          onTap: () {
            _onDateSelected(currentDate);
            setState(() {
              _selectedDate = currentDate;
              _currentView = CalendarView.day; // 월 선택 시 일간으로 전환
            });
          },
          child: Center(child: Text('$month월')),
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
      final currentDate = DateTime(year, 1, 1);
      final isSelected = _isDateSelected(currentDate);

      return GestureDetector(
        onTap: () {
          _onDateSelected(currentDate);
          setState(() {
            _selectedDate = currentDate;
            _currentView = CalendarView.month; // 년도 선택 시 월 보기로 전환
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$year년',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    },
  );
}
}