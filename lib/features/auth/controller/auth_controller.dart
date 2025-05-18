class AuthController {
  static Future<bool> signUp({
    required String name,
    required String gender,
    required String birth,
    required String email,
    required String username,
    required String password,
  }) async {
    // 나중에 실제 서버 요청 로직 추가 예정
    await Future.delayed(const Duration(milliseconds: 300)); // 테스트용 지연
    print('✔ 서버에 회원가입 정보 전송됨');

    // 예시: 성공 처리
    return true;
  }
}
