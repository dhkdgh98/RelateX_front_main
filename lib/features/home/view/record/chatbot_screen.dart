import 'package:flutter/material.dart';
import '../../../auth/controller/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/chat_api.dart';
import 'dart:math';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _messages = []; // {'sender': 'user'|'bot', 'text': '...'}
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? _selectedCategory; // 선택된 카테고리 저장
  AnimationController? _loadingController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

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
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _loadingController?.dispose();
    super.dispose();
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

  Widget _buildLoadingMessage() {
    if (_isLoading && _loadingController != null) {
      _loadingController!.repeat();
    } else if (_loadingController != null) {
      _loadingController!.stop();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoadingDot(0),
            const SizedBox(width: 8),
            _buildLoadingDot(1),
            const SizedBox(width: 8),
            _buildLoadingDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDot(int index) {
    if (_loadingController == null) return const SizedBox();
    
    return AnimatedBuilder(
      animation: _loadingController!,
      builder: (context, child) {
        final value = _loadingController!.value;
        final dotValue = (value - (index * 0.2)) % 1.0;
        final translateY = -4 * sin(dotValue * pi);
        
        return Transform.translate(
          offset: Offset(0, translateY),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
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

    // 로딩 애니메이션이 나타날 때 스크롤
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      final botReply = await ChatApi.sendMessage(
        userId, 
        text,
        category: _selectedCategory,
      );

      if (!mounted) return;

      setState(() {
        if (botReply != null) {
          _messages.add({'sender': 'bot', 'text': botReply});
        } else {
          _messages.add({'sender': 'bot', 'text': '오빠~ 챗봇 응답 실패했어 ㅠㅠ'});
        }
        _isLoading = false;
      });

      // 챗봇 응답이 왔을 때 스크롤
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add({'sender': 'bot', 'text': '오빠~ 오류가 났어용 ㅠㅠ 다시 해줘~'});
        _isLoading = false;
      });

      // 오류 메시지가 왔을 때도 스크롤
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "챗봇과 기록하기 ",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return _buildLoadingMessage();
                  }
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '카테고리:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_selectedCategory != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedCategory!,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...['생각', '이벤트', '대화'].map((category) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    )).toList(),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _selectedCategory == null ? null : () async {
                      if (_messages.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('저장할 대화 내용이 없습니다.')),
                        );
                        return;
                      }

                      final userId = ref.read(authProvider).userId;
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인이 필요합니다.')),
                        );
                        return;
                      }

                      try {
                        final result = await ChatApi.saveChat(
                          userId,
                          _messages,
                          _selectedCategory!,
                        );

                        if (!mounted) return;

                        if (result != null) {
                          // 정리된 내용을 새로운 메시지로 추가
                          setState(() {
                            _messages.add({
                              'sender': 'bot',
                              'text': '📝 정리된 내용:\n\n${result['summary']}',
                            });
                            _selectedCategory = null;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('기록이 완료되었습니다!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('기록 저장에 실패했습니다. 다시 시도해주세요.')),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('기록 저장 중 오류가 발생했습니다.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.save_alt, size: 18),
                    label: const Text('기록하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4EFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: _selectedCategory != null 
                            ? "$_selectedCategory 입력하기..."
                            : "메시지를 입력하세요...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        fillColor: const Color(0xFFF5F5F5),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _isLoading ? null : _sendMessage,
                      color: _isLoading 
                          ? Colors.grey 
                          : const Color.fromARGB(255, 120, 120, 120),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



