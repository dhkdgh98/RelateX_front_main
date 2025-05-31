import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constants/api_config.dart'; // 기본 헤더, 베이스 URL 등

class ChatApi {
  static const String _chatBase = '${ApiConfig.baseUrl}/chat';

  /// 챗봇에게 메시지 전송하고 응답 받기
  static Future<String?> sendMessage(String userId, String userMessage) async {
    final uri = Uri.parse('$_chatBase/reply');

    final bodyData = {
      'userId': userId,
      'message': userMessage,
    };

    print('[DEBUG] 📤 챗봇 요청: $bodyData');

    final response = await http.post(
      uri,
      headers: {
        ...ApiConfig.defaultHeaders,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bodyData),
    );

    print('[DEBUG] 📥 챗봇 응답 상태: ${response.statusCode}');
    print('[DEBUG] 📥 챗봇 응답 내용: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        final botReply = decoded['data']['reply'];
        print('[DEBUG] 🤖 챗봇 응답: $botReply');
        return botReply;
      }
      print('[DEBUG] ❌ 챗봇 응답 형식 오류: ${response.body}');
      return null;
    } else {
      print('[DEBUG] ❌ 챗봇 응답 실패: ${response.statusCode}');
      return null;
    }
  }
}
