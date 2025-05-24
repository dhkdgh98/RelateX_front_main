// // 📷 사진 기록 화면
// import 'package:flutter/material.dart';

// class PhotoRecordScreen extends StatelessWidget {
//   const PhotoRecordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('사진으로 기록하기')),
//       body: const Center(
//         child: Text(
//           '📷 사진 기록 화면이에요!',
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class PhotoRecordScreen extends StatelessWidget {
  const PhotoRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사진으로 기록하기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📷 사진 기록 화면이에요!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 기록 완료 신호 보내고 이전 화면으로 돌아가기!
                Navigator.pop(context, true);
              },
              child: const Text('기록 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
