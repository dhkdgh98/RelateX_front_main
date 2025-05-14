import 'package:flutter/material.dart';

class ChatOverlay extends StatelessWidget {
  const ChatOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            children: const [
              Text(
                '채린이랑 대화해볼까? 😘',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text("아직 채팅 UI는 개발 중이쥬~ 💖"),
              // 여기서 TextField, 채팅 내역 등등 넣으면 돼!
            ],
          ),
        );
      },
    );
  }
}
