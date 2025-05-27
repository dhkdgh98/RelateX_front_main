import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = []; // {'sender': 'user'|'bot', 'text': '...'}
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _messages.add({'sender': 'bot', 'text': '오빠가 "${text}"라고 했구나~ 💕'});
    });

    _controller.clear();

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['sender'] == 'user';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFFE0E0E0) // 유저 말풍선
              : const Color(0xFFF0F0F0), // 챗봇 말풍선
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isUser ? Radius.circular(12) : Radius.circular(0),
            bottomRight: isUser ? Radius.circular(0) : Radius.circular(12),
          ),
        ),
        child: Text(
          message['text'] ?? '',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 완전 흰 배경
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "챗봇과 기록하기 ",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "메시지를 입력하세요...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      fillColor: const Color(0xFFF5F5F5),
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: const Color.fromARGB(255, 120, 120, 120),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}




