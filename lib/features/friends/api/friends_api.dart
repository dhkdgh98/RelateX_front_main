import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constants/api_config.dart';
import 'package:flutter/foundation.dart';

class FriendsApi {
  static String get _friendsBase => ApiConfig.baseUrl;

  static Future<List<Map<String, dynamic>>> getFriends(String userId) async {
    print('[DEBUG] 🔍 현재 baseUrl: ${ApiConfig.baseUrl}');
    final uri = Uri.parse('$_friendsBase/friends?userId=$userId');
    print('[DEBUG] 📡 요청 URL: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {},
      );

      print('[DEBUG] 📥 응답 상태: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final friends = data.map((item) => Map<String, dynamic>.from(item)).toList();
        print('[DEBUG] ✅ 파싱된 친구 목록: $friends');
        return friends;
      } else {
        print('[DEBUG] ❌ 서버 에러: ${response.statusCode} - ${response.body}');
        throw Exception('친구 목록을 불러오는데 실패했습니다. (${response.statusCode})');
      }
    } catch (e) {
      print('[ERROR] 🧨 친구 목록 요청 중 예외 발생: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getRecordOptions(String userId) async {
    print('[DEBUG] 🔍 현재 baseUrl: ${ApiConfig.baseUrl}');
    final uri = Uri.parse('${ApiConfig.baseUrl}/record/options?userId=$userId');
    print('[DEBUG] 📡 요청 URL: $uri');
    print('[DEBUG] 📡 요청 메서드: GET');
    print('[DEBUG] 📡 요청 헤더: {}');

    try {
      print('[DEBUG] 📤 API 요청 시작');
      final response = await http.get(
        uri,
        headers: {},
      );
      print('[DEBUG] 📥 API 응답 수신');

      print('[DEBUG] 📥 응답 상태: ${response.statusCode}');
      print('[DEBUG] 📥 응답 헤더: ${response.headers}');
      print('[DEBUG] 📥 응답 바디: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('[DEBUG] ✅ 파싱된 RecordOption: $data');
        return data;
      } else {
        print('[DEBUG] ❌ 서버 에러: ${response.statusCode} - ${response.body}');
        throw Exception('RecordOption을 불러오는데 실패했습니다. (${response.statusCode})');
      }
    } catch (e, stackTrace) {
      print('[ERROR] 🧨 RecordOption 요청 중 예외 발생: $e');
      print('[ERROR] 📚 스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addFriend({
    required String userId,
    required String name,
    required String mbti,
    required String birthday,
    List<String>? interests,
    List<String>? tags,
  }) async {
    print('[DEBUG] 🔍 현재 baseUrl: ${ApiConfig.baseUrl}');
    final uri = Uri.parse('$_friendsBase/friends');
    print('[DEBUG] 📡 요청 URL: $uri');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'name': name,
          'mbti': mbti,
          'birthday': birthday,
          'interests': interests ?? [],
          'tags': tags ?? [],
        }),
      );

      print('[DEBUG] 📥 응답 상태: ${response.statusCode}');
      print('[DEBUG] 📦 응답 내용: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('[DEBUG] ✅ 친구 추가 성공: $data');
        return data;
      } else {
        print('[DEBUG] ❌ 서버 에러: ${response.statusCode} - ${response.body}');
        throw Exception('친구 추가에 실패했습니다. (${response.statusCode})');
      }
    } catch (e) {
      print('[ERROR] 🧨 친구 추가 중 예외 발생: $e');
      rethrow;
    }
  }

  static Future<void> deleteFriend(String friendId) async {
    print('[DEBUG] 🔍 현재 baseUrl: ${ApiConfig.baseUrl}');
    final uri = Uri.parse('$_friendsBase/friends/$friendId');
    print('[DEBUG] 📡 요청 URL: $uri');

    try {
      final response = await http.delete(
        uri,
        headers: {},
      );

      print('[DEBUG] 📥 응답 상태: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('[DEBUG] ✅ 친구 삭제 성공');
      } else {
        print('[DEBUG] ❌ 서버 에러: ${response.statusCode} - ${response.body}');
        throw Exception('친구 삭제에 실패했습니다. (${response.statusCode})');
      }
    } catch (e) {
      print('[ERROR] 🧨 친구 삭제 중 예외 발생: $e');
      rethrow;
    }
  }
} 