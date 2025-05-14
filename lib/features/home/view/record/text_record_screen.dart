// ✍️ 텍스트 기록 화면
import 'package:flutter/material.dart';

class TextRecordScreen extends StatelessWidget {
  const TextRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('텍스트로 기록하기')),
      body: const Center(
        child: Text(
          '✍️ 텍스트 기록 화면이에요!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
