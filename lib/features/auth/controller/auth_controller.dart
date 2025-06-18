import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:relate_x_front_main/constants/api_config.dart';
import 'package:relate_x_front_main/constants/api_headers.dart';

class AuthController {
  static final String _authBase = '${ApiConfig.baseUrl}/auth';

  // 회원가입
  static Future<bool> signUp({
    required String name,
    required String gender,
    required String birth,
    required String email,
    required String username,
    required String password,
  }) async {
    String genderValue = (gender == '여자') ? 'female' : 'male';

    try {
      final response = await http.post(
        Uri.parse('$_authBase/signup'),
        headers: apiHeaders,
        body: jsonEncode({
          'name': name,
          'gender': genderValue,
          'birthday': birth,
          'email': email,
          'user_id': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        print('✔ 회원가입 성공!');
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        print('❌ 회원가입 실패: ${responseBody['message']}');
        return false;
      }
    } catch (e) {
      print('🚨 회원가입 요청 중 오류 발생: $e');
      return false;
    }
  }

  // // 로그인
  // static Future<String?> login({
  //   required String username,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_authBase/login'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'user_id': username,
  //         'password': password,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print('✔ 로그인 성공!');
  //       return data['userId'];
  //     } else {
  //       final responseBody = jsonDecode(response.body);
  //       print('❌ 로그인 실패: ${responseBody['message']}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('🚨 로그인 요청 중 오류 발생: $e');
  //     return null;
  //   }

  static Future<String?> login({
  required String username,
  required String password,
}) async {
  try {
    final response = await http
        .post(
          Uri.parse('$_authBase/login'),
            headers: apiHeaders,
          body: jsonEncode({
            'user_id': username,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 5)); // ⏰ 5초 제한!

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✔ 로그인 성공!');
      return data['userId'];
    } else {
      final responseBody = jsonDecode(response.body);
      print('❌ 로그인 실패: ${responseBody['message']}');
      return null;
    }
  } on http.ClientException catch (e) {
    print('🚨 클라이언트 오류 발생: $e');
    return null;
  } on TimeoutException {
    print('⏳ 로그인 시간이 너무 오래 걸려서 타임아웃됐어… 다시 시도해줘!');
    return null;
  } catch (e) {
    print('🚨 로그인 요청 중 알 수 없는 오류 발생: $e');
    return null;
  }
  }
}
