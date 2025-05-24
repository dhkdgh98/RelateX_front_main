import 'package:flutter/material.dart';

enum RecordType { photo, text, voice, chatbot }

class RecordBoxWidget extends StatelessWidget {
  final void Function(RecordType) onRecordTypeSelected;

  const RecordBoxWidget({super.key, required this.onRecordTypeSelected});

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
                Icons.photo_camera,
                () => onRecordTypeSelected(RecordType.photo),
              ),
              const SizedBox(width: 16),
              _buildRecordButton(
                Icons.edit,
                () => onRecordTypeSelected(RecordType.text),
              ),
              const SizedBox(width: 16),
              _buildRecordButton(
                Icons.mic,
                () => onRecordTypeSelected(RecordType.voice),
              ),
              const SizedBox(width: 16),
              _buildRecordButton(
                Icons.chat_bubble_outline,
                () => onRecordTypeSelected(RecordType.chatbot),
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

  Widget _buildRecordButton(IconData icon, VoidCallback onTap) {
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

