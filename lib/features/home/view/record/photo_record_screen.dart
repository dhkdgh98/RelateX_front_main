// 📷 사진 기록 화면
import 'package:flutter/material.dart';

class PhotoRecordScreen extends StatelessWidget {
  const PhotoRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사진으로 기록하기')),
      body: const Center(
        child: Text(
          '📷 사진 기록 화면이에요!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
