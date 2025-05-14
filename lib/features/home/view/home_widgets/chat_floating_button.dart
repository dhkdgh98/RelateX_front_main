import 'package:flutter/material.dart';
import 'chat_overlay.dart';

class ChatFloatingButton extends StatelessWidget {
  const ChatFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(216, 249, 247, 247),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => const ChatOverlay(),
        );
      },
      child: const Icon(Icons.chat),
    );
  }
}
