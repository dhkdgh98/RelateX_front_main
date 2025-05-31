import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:relate_x_front_main/constants/api_config.dart';

class HomeApi {
  static final String _homeBase = '${ApiConfig.baseUrl}/home';

  static Future<List<dynamic>> getTimeline(String userId) async {
    print('[DEBUG] 🔍 현재 baseUrl: ${ApiConfig.baseUrl}');
    final uri = Uri.parse('$_homeBase/timeline?userId=$userId');
    print('[DEBUG] 📡 요청 URL: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {},
      );

      print('[DEBUG] 📥 응답 상태: ${response.statusCode}');
      print('[DEBUG] 📥 응답 내용: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List;
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
    final uri = Uri.parse('$_homeBase/record');
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
}
