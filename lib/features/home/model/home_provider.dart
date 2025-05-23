// 📁 lib/features/home/provider/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_provider.dart';
import '../model/home_model.dart';
import '../api/home_api.dart';

final homeProvider = FutureProvider<List<TimelineEntry>>((ref) async {
  final userId = ref.watch(authProvider).userId;

  if (userId == null || userId.isEmpty) {
    return []; // 로그인 안 됐을 때 빈 리스트 반환
  }

  try {
    final jsonList = await HomeApi.getTimeline(userId);
    return jsonList.map((json) => TimelineEntry.fromJson(json)).toList();
  } catch (e) {
    throw Exception('타임라인 불러오기 실패: $e');
  }
});
