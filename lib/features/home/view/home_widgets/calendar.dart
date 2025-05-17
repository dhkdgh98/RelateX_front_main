import 'package:flutter/material.dart';

class CalendarModal extends StatelessWidget {
  const CalendarModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // 원하는 높이
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text('📅 여기에 캘린더 위젯 들어갈 예정~', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
