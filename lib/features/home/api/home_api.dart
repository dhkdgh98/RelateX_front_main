import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:relate_x_front_main/constants/api_config.dart';
import 'package:flutter/foundation.dart';


class HomeApi {
  static String get _homeBase => ApiConfig.baseUrl;

  static Future<List<dynamic>> getTimeline(String userId) async {
    print('[DEBUG] 🔍 현재 baseUrl: ${ApiConfig.baseUrl}');
    final uri = Uri.parse('$_homeBase/home/timeline?userId=$userId');
    print('[DEBUG] 📡 요청 URL: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {},
      );

      print('[DEBUG] 📥 응답 상태: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> timelineData = jsonDecode(response.body) as List;
        return timelineData;
      } else {
        throw Exception('타임라인 데이터 요청 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('[ERROR] 🧨 타임라인 요청 중 예외 발생: $e');
      rethrow;
    }
  }

  static Future<bool> postRecord(
    String userId,
    Map<String, dynamic> recordData, [
    List<XFile>? selectedImages,
  ]) async {
    print('[DEBUG] 🔍 현재 baseUrl: ${ApiConfig.baseUrl}');
    final uri = Uri.parse('$_homeBase/home/record');
    print('[DEBUG] 📡 요청 URL: $uri');

    try {
      // 📄 텍스트 기록
      if (selectedImages == null || selectedImages.isEmpty) {
        final dataWithUserId = {
          'userId': userId,
          ...recordData,
        };

        print('[DEBUG] 📤 요청 데이터: $dataWithUserId');

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(dataWithUserId),
        );

        print('[DEBUG] 📥 응답 상태: ${response.statusCode}');
        print('[DEBUG] 📥 응답 내용: ${response.body}');

        if (response.statusCode == 201) {
          print('[DEBUG] ✅ 텍스트 기록 저장 성공!');
          return true;
        } else {
          print('[DEBUG] ❌ 텍스트 기록 저장 실패, 상태 코드: ${response.statusCode}');
          return false;
        }
      }

      // 🖼 이미지 포함 기록
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      request.fields['userId'] = userId;
      recordData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      print('[DEBUG] 📤 요청 필드: ${request.fields}');

      for (var image in selectedImages) {
        final multipartFile = await http.MultipartFile.fromPath('images', image.path);
        request.files.add(multipartFile);
        print('[DEBUG] 📤 이미지 추가: ${image.path}');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('[DEBUG] 📥 응답 상태: ${response.statusCode}');
      print('[DEBUG] 📥 응답 내용: ${response.body}');

      if (response.statusCode == 201) {
        print('[DEBUG] ✅ 이미지 포함 기록 저장 성공!');
        return true;
      } else {
        print('[DEBUG] ❌ 이미지 기록 저장 실패, 상태 코드: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      print('[ERROR] 🧨 예외 발생: $e');
      print('[ERROR] 📚 스택 트레이스: $stackTrace');
      return false;
    }
  }

  static Future<void> deleteRecord(String id) async {
    try {
      debugPrint('[DEBUG] 🗑 기록 삭제 요청 - ID: $id');
      debugPrint('[DEBUG] 📡 요청 URL: $_homeBase/home/records/$id');

      final response = await http.delete(
        Uri.parse('$_homeBase/home/records/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint('[DEBUG] 📥 응답 상태 코드: ${response.statusCode}');
      debugPrint('[DEBUG] 📥 응답 내용: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('기록 삭제 실패: ${response.body}');
      }
    } catch (e) {
      debugPrint('[DEBUG] ❌ 기록 삭제 오류: $e');
      rethrow;
    }
  }

  static Future<Map<String, List<String>>> getRecordOptions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_homeBase/record/options?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'friends': List<String>.from(data['friends']),
          'locations': List<String>.from(data['locations']),
          'emotions': List<String>.from(data['emotions']),
          'categories': List<String>.from(data['categories']),
          'recordTypes': List<String>.from(data['recordTypes']),
        };
      } else {
        throw Exception('Failed to load record options');
      }
    } catch (e) {
      print('Error loading record options: $e');
      // 기본 옵션 반환
      return {
        'friends': ['나', '가족', '친구', '동료', '연인', '기타'],
        'locations': ['집', '회사', '학교', '카페', '공원', '도서관', '자취방', '영화관', '기타'],
        'emotions': ['행복', '기쁨', '설렘', '평온', '차분함', '불안', '걱정', '슬픔', '화남', '자신감', '의욕', '피곤함', '지루함', '기타'],
        'categories': ['일상', '성장', '자기성찰', '관계', '건강', '취미', '학업', '직장', '기타'],
        'recordTypes': ['이벤트', '생각', '대화', '느낌', '목표', '성취', '기타'],
      };
    }
  }

  static Future<Map<String, List<String>>> updateRecordOptions(
    String userId,
    Map<String, List<String>> options,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_homeBase/record/options?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(options),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'friends': List<String>.from(data['options']['friends']),
          'locations': List<String>.from(data['options']['locations']),
          'emotions': List<String>.from(data['options']['emotions']),
          'categories': List<String>.from(data['options']['categories']),
          'recordTypes': List<String>.from(data['options']['recordTypes']),
        };
      } else {
        throw Exception('Failed to update record options');
      }
    } catch (e) {
      print('Error updating record options: $e');
      rethrow;
    }
  }

  static Future<List<String>> addOption(
    String userId,
    String category,
    String value,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_homeBase/record/options/add?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'category': category,
          'value': value,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['options']);
      } else {
        throw Exception('Failed to add option');
      }
    } catch (e) {
      print('Error adding option: $e');
      rethrow;
    }
  }
}
