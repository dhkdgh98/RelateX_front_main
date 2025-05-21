

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  static Future<bool> signUp({
    required String name,
    required String gender,
    required String birth,
    required String email,
    required String username,
    required String password,
  }) async {
    const String apiUrl = 'http://192.168.0.7:8080/signup';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'gender': gender,
          'birthday': birth,
          'email': email,
          'user_id': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print('✔ 회원가입 성공!');
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        print('❌ 회원가입 실패: ${responseBody['message']}');
        return false;
      }
    } catch (e) {
      print('🚨 서버 요청 중 오류 발생: $e');
      return false;
    }
  }
}
