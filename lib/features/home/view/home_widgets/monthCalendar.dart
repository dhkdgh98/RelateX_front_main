import 'package:flutter/material.dart';

// �ս� Ķ������ ǥ���ϴ� ����
class MonthCalendarView extends StatelessWidget {
  const MonthCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'May 2025',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // �޷� ���̾ƿ��� ���⿡ �߰�
          // ���� ��� GridView�� ����� �� ����
        ],
      ),
    );
  }
}
