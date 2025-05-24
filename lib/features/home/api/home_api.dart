
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class HomeApi {
  static const String baseUrl = 'http://192.168.0.5:5000/api/home';

  /// 📌 타임라인 가져오기 (userId 필요!)
  static Future<List<dynamic>> getTimeline(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/timeline?userId=$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('타임라인 데이터 요청 실패');
    }
  }



// static Future<bool> postRecord(
//   String userId,
//   Map<String, dynamic> recordData,
//   List<XFile> selectedImages,
// ) async {
//   final uri = Uri.parse('$baseUrl/record'); // 오빠의 서버 주소

//   // 🖼 이미지가 하나 이상 있을 때: Multipart 방식으로 전송
//   if (selectedImages.isNotEmpty) {
//     var request = http.MultipartRequest('POST', uri);

//     // ✍️ 일반 필드 추가
//     request.fields['userId'] = userId;
//     recordData.forEach((key, value) {
//       if (value != null) {
//         request.fields[key] = value.toString();
//       }
//     });

//     // 🖼 이미지 파일들 추가
//     for (var image in selectedImages) {
//       var multipartFile = await http.MultipartFile.fromPath('images', image.path);
//       request.files.add(multipartFile);
//     }

//     try {
//       final response = await request.send();

//       if (response.statusCode == 201) {
//         print('[DEBUG] ✅ (Multipart) 기록 저장 성공!');
//         return true;
//       } else {
//         print('[DEBUG] ❌ (Multipart) 저장 실패, 상태 코드: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('[ERROR] 🧨 (Multipart) 예외 발생: $e');
//       return false;
//     }
//   }

//   // 📄 이미지가 없을 때: JSON 방식으로 전송
//   final dataWithUserId = {
//     'userId': userId,
//     ...recordData,
//   };

//   try {
//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(dataWithUserId),
//     );

//     if (response.statusCode == 201) {
//       print('[DEBUG] ✅ (JSON) 기록 저장 성공!');
//       return true;
//     } else {
//       print('[DEBUG] ❌ (JSON) 저장 실패, 상태 코드: ${response.statusCode}');
//       return false;
//     }
//   } catch (e) {
//     print('[ERROR] 🧨 (JSON) 예외 발생: $e');
//     return false;
//   }
// }

static Future<bool> postRecord(
  String userId,
  Map<String, dynamic> recordData, [
  List<XFile>? selectedImages,
]) async {
  final uri = Uri.parse('$baseUrl/record');

  // 📸 이미지가 없으면 JSON 방식
  if (selectedImages == null || selectedImages.isEmpty) {
    final dataWithUserId = {
      'userId': userId,
      ...recordData,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
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

  // 🖼 이미지가 있을 경우 Multipart 방식
  var request = http.MultipartRequest('POST', uri);

  request.fields['userId'] = userId;
  recordData.forEach((key, value) {
    if (value != null) {
      request.fields[key] = value.toString();
    }
  });

  for (var image in selectedImages) {
    var multipartFile = await http.MultipartFile.fromPath('images', image.path);
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
