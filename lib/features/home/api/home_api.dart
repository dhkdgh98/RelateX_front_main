
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  /// 📝 기록 저장하기 (userId 직접 받음)
  static Future<bool> postRecord(String userId, Map<String, dynamic> recordData) async {
    final dataWithUserId = {
      'userId': userId,
      ...recordData,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/record'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dataWithUserId),
    );

    return response.statusCode == 201;
  }
}
