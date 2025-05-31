// chatbot_model.dart

class ChatMessage {
  final String sender; // 'user' or 'bot'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'] ?? 'bot',
      text: json['text'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ChatModel {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  /// 메시지 추가
  void addMessage(ChatMessage message) {
    _messages.add(message);
  }

  /// 전체 메시지 초기화
  void clearMessages() {
    _messages.clear();
  }
}
