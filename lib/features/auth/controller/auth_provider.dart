

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 어디서든 userId 쉽게 꺼내 쓰기 위한 헬퍼
String? getUserId(WidgetRef ref) {
  return ref.read(authProvider).userId;
}


// Auth 상태 클래스
class AuthState {
  final String? userId;
  bool get isLoggedIn => userId != null;  // 여기서 final 빼줬어~

  AuthState({this.userId});
  
  AuthState copyWith({String? userId}) {
    return AuthState(userId: userId ?? this.userId);
  }
}

// AuthNotifier: 상태를 관리하는 클래스
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void setUserId(String userId) {
    state = state.copyWith(userId: userId);
  }

  void logout() {
    state = AuthState(userId: null);
  }
}

// Provider 선언
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
