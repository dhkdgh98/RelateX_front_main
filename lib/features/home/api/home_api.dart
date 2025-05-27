
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class HomeApi {
//   static const String baseUrl = 'https://e4af-175-204-236-26.ngrok-free.app/api/home';

//   static Future<List<dynamic>> getTimeline(String userId) async {
//     final uri = Uri.parse('$baseUrl/timeline?userId=$userId');
//     print('[DEBUG] 요청 URL: $uri');

//     final response = await http.get(
//       uri,
//       headers: {
//         'ngrok-skip-browser-warning': 'true',
//       },
//     );

//     print('[DEBUG] 응답 상태: ${response.statusCode}');

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List;
//     } else {
//       throw Exception('타임라인 데이터 요청 실패');
//     }
//   }






// static Future<bool> postRecord(
//   String userId,
//   Map<String, dynamic> recordData, [
//   List<XFile>? selectedImages,
// ]) async {
//   final uri = Uri.parse('$baseUrl/record');

//   // 📄 텍스트 기록만 있는 경우
//   if (selectedImages == null || selectedImages.isEmpty) {
//     final dataWithUserId = {
//       'userId': userId,
//       ...recordData,
//     };

//     final response = await http.post(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'ngrok-skip-browser-warning': 'true',
//       },
//       body: jsonEncode(dataWithUserId),
//     );

//     if (response.statusCode == 201) {
//       print('[DEBUG] ✅ 텍스트 기록 저장 성공!');
//       return true;
//     } else {
//       print('[DEBUG] ❌ 텍스트 기록 저장 실패, 상태 코드: ${response.statusCode}');
//       return false;
//     }
//   }

//   // 🖼 이미지가 포함된 기록 저장
//   final request = http.MultipartRequest('POST', uri);
//   request.headers['ngrok-skip-browser-warning'] = 'true';

//   request.fields['userId'] = userId;
//   recordData.forEach((key, value) {
//     if (value != null) {
//       request.fields[key] = value.toString();
//     }
//   });

//   for (var image in selectedImages) {
//     final multipartFile = await http.MultipartFile.fromPath(
//       'images', // 서버에 따라 'images[]'일 수도 있어!
//       image.path,
//     );
//     request.files.add(multipartFile);
//   }

//   try {
//     final response = await request.send();

//     if (response.statusCode == 201) {
//       print('[DEBUG] ✅ 이미지 포함 기록 저장 성공!');
//       return true;
//     } else {
//       print('[DEBUG] ❌ 이미지 기록 저장 실패, 상태 코드: ${response.statusCode}');
//       return false;
//     }
//   } catch (e) {
//     print('[ERROR] 🧨 예외 발생: $e');
//     return false;
//   }
// }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:relate_x_front_main/constants/api_config.dart'; // ✅ 새로 만든 파일 불러오기

class HomeApi {
  static final String _homeBase = '${ApiConfig.baseUrl}/home';

  static Future<List<dynamic>> getTimeline(String userId) async {
    final uri = Uri.parse('$_homeBase/timeline?userId=$userId');
    print('[DEBUG] 요청 URL: $uri');

    final response = await http.get(
      uri,
      headers: ApiConfig.defaultHeaders,
    );

    print('[DEBUG] 응답 상태: ${response.statusCode}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('타임라인 데이터 요청 실패');
    }
  }

  static Future<bool> postRecord(
    String userId,
    Map<String, dynamic> recordData, [
    List<XFile>? selectedImages,
  ]) async {
    final uri = Uri.parse('$_homeBase/record');

    // 📄 텍스트 기록
    if (selectedImages == null || selectedImages.isEmpty) {
      final dataWithUserId = {
        'userId': userId,
        ...recordData,
      };

      final response = await http.post(
        uri,
        headers: {
          ...ApiConfig.defaultHeaders,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dataWithUserId),
      );

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
    request.headers.addAll(ApiConfig.defaultHeaders);

    request.fields['userId'] = userId;
    recordData.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    for (var image in selectedImages) {
      final multipartFile = await http.MultipartFile.fromPath('images', image.path);
      request.files.add(multipartFile);
    }

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        print('[DEBUG] ✅ 이미지 포함 기록 저장 성공!');
        return true;
      } else {
        print('[DEBUG] ❌ 이미지 기록 저장 실패, 상태 코드: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('[ERROR] 🧨 예외 발생: $e');
      return false;
    }
  }
}
