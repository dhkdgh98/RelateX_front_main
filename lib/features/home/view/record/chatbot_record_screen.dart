// 🤖 챗봇 기록 화면
import 'package:flutter/material.dart';

class ChatbotRecordScreen extends StatelessWidget {
  const ChatbotRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챗봇과 대화하기')),
      body: const Center(
        child: Text(
          '🤖 챗봇 기록 화면이에요!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
