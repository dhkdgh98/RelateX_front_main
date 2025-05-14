import 'package:flutter/material.dart';



class WeekCalendarHeader extends StatelessWidget {
  const WeekCalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // 요일 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final days = ['월', '화', '수', '목', '금', '토', '일'];
              return SizedBox(
                width: 40,
                child: Text(
                  days[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: index == 6 ? Colors.red : Colors.black87,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // 날짜 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final date = firstDayOfWeek.add(Duration(days: index));
              final isToday = date.day == now.day && 
                            date.month == now.month && 
                            date.year == now.year;
              
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday ? Colors.blue.withOpacity(0.1) : null,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: index == 6 ? Colors.red : Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
