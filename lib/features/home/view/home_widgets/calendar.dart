import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum CalendarView { day, month, year }

class CalendarModal extends StatefulWidget {
  final Function(DateTime?, DateTime?) onDateRangeSelected;

  const CalendarModal({
    super.key,
    required this.onDateRangeSelected,
  });

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  CalendarView _currentView = CalendarView.day;
  DateTime _selectedDate = DateTime.now();
  bool _isRangeEnabled = false;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    // 초기화 시에는 필터링을 하지 않음
  }

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
        widget.onDateRangeSelected(_rangeStart, _rangeEnd);
      } else {
        _selectedDate = date;
        widget.onDateRangeSelected(date, date);
      }
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
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
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isRangeEnabled = !_isRangeEnabled;
                          if (!_isRangeEnabled) {
                            _rangeStart = null;
                            _rangeEnd = null;
                            widget.onDateRangeSelected(_selectedDate, _selectedDate);
                          }
                        });
                      },
                      icon: Icon(
                        _isRangeEnabled ? Icons.check_box : Icons.check_box_outline_blank,
                      ),
                      label: const Text('기간 선택'),
                    ),
                    const SizedBox(width: 8),
                    // ✅ 초기화 버튼
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rangeStart = null;
                          _rangeEnd = null;
                          _selectedDate = DateTime.now();
                          widget.onDateRangeSelected(null, null);
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.refresh, size: 18, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                // 뷰 전환 드롭다운
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
                    DropdownMenuItem(value: CalendarView.month, child: Text('월')),
                    DropdownMenuItem(value: CalendarView.year, child: Text('년')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 3),
            _buildHeader(),
            const SizedBox(height: 8),
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        if (_isRangeEnabled) _buildRangeInputFields(), // ✅ 맨 위에 추가!
        Row(
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
        ),
      ],
    );
  }

  Widget _buildRangeInputFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        children: [
          _buildDateInputField(
            label: '시작일',
            initialDate: _rangeStart,
            onDateParsed: (date) => setState(() => _rangeStart = date),
          ),
          const SizedBox(width: 12),
          _buildDateInputField(
            label: '종료일',
            initialDate: _rangeEnd,
            onDateParsed: (date) => setState(() => _rangeEnd = date),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInputField({
    required String label,
    required DateTime? initialDate,
    required void Function(DateTime) onDateParsed,
  }) {
    final controller = TextEditingController(
      text: initialDate != null ? DateFormat('yyyy.MM.dd').format(initialDate) : '',
    );

    return Expanded(
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13), // ✅ 폰트 작게
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          hintText: '예: 20200101',
          hintStyle: const TextStyle(fontSize: 12),
        ),
        keyboardType: TextInputType.number,
        onSubmitted: (value) {
          final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleaned.length == 8) {
            final year = int.tryParse(cleaned.substring(0, 4));
            final month = int.tryParse(cleaned.substring(4, 6));
            final day = int.tryParse(cleaned.substring(6, 8));
            if (year != null && month != null && day != null) {
              try {
                final date = DateTime(year, month, day);
                onDateParsed(date);
              } catch (_) {
                // 날짜 형식 오류 무시
              }
            }
          }
        },
      ),
    );
  }

  Widget _buildCalendarContent() {
    switch (_currentView) {
      case CalendarView.day:
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
          isRangeSelected = !currentDate.isBefore(_rangeStart!) && !currentDate.isAfter(_rangeEnd!);
        } else if (_rangeStart != null && _rangeEnd == null) {
          isRangeSelected = currentDate == _rangeStart;
        }

        final isSingleSelected = !_isRangeEnabled &&
            currentDate.year == _selectedDate.year &&
            currentDate.month == _selectedDate.month &&
            currentDate.day == _selectedDate.day;

        final isToday = currentDate.year == DateTime.now().year &&
            currentDate.month == DateTime.now().month &&
            currentDate.day == DateTime.now().day;

        return GestureDetector(
          onTap: () => _onDateSelected(currentDate),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isRangeSelected || isSingleSelected
                  ? Colors.grey.withOpacity(0.3)
                  : null,
              border: isToday
                  ? Border.all(color: Colors.black, width: 1.5)
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

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, month, _selectedDate.day);
              _currentView = CalendarView.day;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            child: Center(
              child: Text(
                '$month월',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black, // ✅ 고정된 텍스트 색상
                ),
              ),
            ),
          ),
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
        final isSelected = _isToday(currentDate);

        return GestureDetector(
          onTap: () {
            setState(() {
              // ✅ 날짜 선택은 하지 않고, 월 보기로만 전환
              _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day);
              _currentView = CalendarView.month;
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