// 🎙️ 음성 기록 화면
import 'package:flutter/material.dart';

class VoiceRecordScreen extends StatelessWidget {
  const VoiceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('음성으로 기록하기')),
      body: const Center(
        child: Text(
          '🎙️ 음성 기록 화면이에요!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
