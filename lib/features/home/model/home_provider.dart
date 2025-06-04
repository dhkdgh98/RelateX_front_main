// 📁 lib/features/home/provider/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_provider.dart';
import 'timeline_model.dart';
import '../api/home_api.dart';
import 'package:flutter/foundation.dart';

final homeProvider = FutureProvider<List<TimelineEntry>>((ref) async {
  final userId = ref.watch(authProvider).userId;

  if (userId == null || userId.isEmpty) {
    return []; // 로그인 안 됐을 때 빈 리스트 반환
  }

  // userId가 'guest'인 경우 (빈칸 로그인) 목업 데이터 반환
  if (userId == 'guest') {
    return mockEntries;
  }

  // 정상 로그인 시 서버에서 데이터 가져오기
  try {
    final jsonList = await HomeApi.getTimeline(userId);
    return jsonList.map((json) => TimelineEntry.fromJson(json)).toList();
  } catch (e) {
    throw Exception('타임라인 불러오기 실패: $e');
  }
});

final recordOptionsProvider = FutureProvider<Map<String, List<String>>>((ref) async {
  final userId = ref.watch(authProvider).userId;
  if (userId == null) {
    throw Exception('로그인이 필요합니다.');
  }
  return await HomeApi.getRecordOptions(userId);
});
