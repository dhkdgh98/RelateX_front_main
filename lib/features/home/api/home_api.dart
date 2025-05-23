import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeApi {
  static const String baseUrl = 'http://192.168.0.5:5000/api/home';

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
}