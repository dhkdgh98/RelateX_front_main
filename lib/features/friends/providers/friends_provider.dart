import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/friends_api.dart';
import '../../auth/controller/auth_provider.dart';
import 'package:flutter/foundation.dart';

final friendsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final userId = ref.watch(authProvider).userId;
  debugPrint('[DEBUG] 🔍 친구 목록 요청 - userId: $userId');

  if (userId == null || userId.isEmpty) {
    debugPrint('[DEBUG] ⚠️ userId가 없음 - 빈 리스트 반환');
    return []; // 로그인 안 됐을 때 빈 리스트 반환
  }

  // userId가 'guest'인 경우 빈 리스트 반환
  if (userId == 'guest') {
    debugPrint('[DEBUG] 👤 게스트 모드 - 빈 리스트 반환');
    return [];
  }

  // 정상 로그인 시 서버에서 데이터 가져오기
  try {
    debugPrint('[DEBUG] 📡 서버에서 친구 목록 요청 중...');
    final friends = await FriendsApi.getFriends(userId);
    debugPrint('[DEBUG] ✅ 친구 목록 로드 성공 - ${friends.length}명의 친구');
    return friends;
  } catch (e) {
    debugPrint('[DEBUG] ❌ 친구 목록 로드 실패: $e');
    throw Exception('친구 목록 불러오기 실패: $e');
  }
}); 