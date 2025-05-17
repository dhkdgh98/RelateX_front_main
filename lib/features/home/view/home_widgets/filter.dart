import 'package:flutter/material.dart';

class FilterModal extends StatelessWidget {
  const FilterModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text('🔍 여기에 필터 옵션들 들어갈 예정~', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
