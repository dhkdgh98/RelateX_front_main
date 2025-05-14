import 'package:flutter/material.dart';
import '../record/photo_record_screen.dart';
import '../record/text_record_screen.dart';
import '../record/voice_record_screen.dart';
import '../record/chatbot_record_screen.dart';

class RecordBoxWidget extends StatelessWidget {
  const RecordBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRecordButton(
                context,
                Icons.photo_camera,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhotoRecordScreen(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildRecordButton(
                context,
                Icons.edit,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TextRecordScreen(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildRecordButton(
                context,
                Icons.mic,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VoiceRecordScreen(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildRecordButton(
                context,
                Icons.chat_bubble_outline,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatbotRecordScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          bottom: 10,
          child: Row(
            children: const [
              Text(
                'RECORD',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 3),
              Icon(
                Icons.radio_button_on,
                size: 10,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 36,
          color: Colors.black87,
        ),
      ),
    );
  }
}
