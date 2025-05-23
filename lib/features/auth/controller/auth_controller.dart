


// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // 🌐 공통 API 주소를 상수로 관리
// const String baseUrl = 'http://192.168.0.5:5000/api/auth';

// class AuthController {
//   // 회원가입
//   static Future<bool> signUp({
//     required String name,
//     required String gender,  // "남자" or "여자"
//     required String birth,
//     required String email,
//     required String username,
//     required String password,
//   }) async {
//     // gender 변환
//     String genderValue;
//     if (gender == '남자') {
//       genderValue = 'male';
//     } else if (gender == '여자') {
//       genderValue = 'female';
//     } else {
//       genderValue = 'male'; // 기본값
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/signup'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'name': name,
//           'gender': genderValue,
//           'birthday': birth,
//           'email': email,
//           'user_id': username,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 201) {
//         print('✔ 회원가입 성공!');
//         return true;
//       } else {
//         final responseBody = jsonDecode(response.body);
//         print('❌ 회원가입 실패: ${responseBody['message']}');
//         return false;
//       }
//     } catch (e) {
//       print('🚨 회원가입 요청 중 오류 발생: $e');
//       return false;
//     }
//   }



// static Future<String?> login({
//   required String username,
//   required String password,
// }) async {
//   try {
//     final response = await http.post(
//       Uri.parse('$baseUrl/login'),
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
//       return data['userId'];  // userId 반환!
//     } else {
//       final responseBody = jsonDecode(response.body);
//       print('❌ 로그인 실패: ${responseBody['message']}');
//       return null;
//     }
//   } catch (e) {
//     print('🚨 로그인 요청 중 오류 발생: $e');
//     return null;
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

// 🌐 공통 API 주소를 상수로 관리
const String baseUrl = 'http://192.168.0.5:5000/api/auth';

class AuthController {
  // 회원가입
  static Future<bool> signUp({
    required String name,
    required String gender,  // "남자" or "여자"
    required String birth,
    required String email,
    required String username,
    required String password,
  }) async {
    // gender 변환
    String genderValue;
    if (gender == '남자') {
      genderValue = 'male';
    } else if (gender == '여자') {
      genderValue = 'female';
    } else {
      genderValue = 'male'; // 기본값
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
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

  // 로그인
  static Future<String?> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✔ 로그인 성공!');
        return data['userId'];  // 서버에서 userId 키로 받아옴
      } else {
        final responseBody = jsonDecode(response.body);
        print('❌ 로그인 실패: ${responseBody['message']}');
        return null;
      }
    } catch (e) {
      print('🚨 로그인 요청 중 오류 발생: $e');
      return null;
    }
  }
}
