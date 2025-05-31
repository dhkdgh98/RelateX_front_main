import 'package:flutter/material.dart';
import '../../../auth/controller/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/chat_api.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
  
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final List<Map<String, String>> _messages = []; // {'sender': 'user'|'bot', 'text': '...'}
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false; // 여기에 선언해야 해요~!

  @override
  void initState() {
    super.initState();



    // ✅ 초기 챗봇 메시지 추가
_messages.add({
  'sender': 'bot',
  'text': '오늘은 어떤 일이 있었나요?\n\n'
      '생각, 이벤트, 대화 중에서\n'
      '기록하고 싶은 내용을 입력해주세요~\n'
      '자동으로 기록해줄게요~ 😊',
});

    // 💬 자동 스크롤도 OK! (postFrameCallback으로 빌드 후 실행되게 처리)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    final userId = ref.read(authProvider).userId;

    if (text.isEmpty || userId == null) {
      if (userId == null && mounted) {
        debugPrint('[DEBUG] ❌ 유저 ID 없음. 로그인 필요!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
      }
      return;
    }

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });

    _controller.clear();

    try {
      final botReply = await ChatApi.sendMessage(userId, text);

      if (!mounted) return;

      setState(() {
        if (botReply != null) {
          _messages.add({'sender': 'bot', 'text': botReply});
        } else {
          _messages.add({'sender': 'bot', 'text': '오빠~ 챗봇 응답 실패했어 ㅠㅠ'});
        }
        _isLoading = false;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add({'sender': 'bot', 'text': '오빠~ 오류가 났어용 ㅠㅠ 다시 해줘~'});
        _isLoading = false;
      });
    }
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



