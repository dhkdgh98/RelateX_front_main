
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // 계정 설정 메인 타이틀
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '계정 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // 흐린 선
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),

          // 계정 설정 세부 항목들
          ListTile(
            title: const Text('이메일 변경'),
            onTap: () {
              // 이메일 변경 페이지 이동
            },
          ),
          ListTile(
            title: const Text('비밀번호 변경'),
            onTap: () {
              // 비밀번호 변경 페이지 이동
            },
          ),
          ListTile(
            title: const Text('프로필 사진 변경'),
            onTap: () {
              // 프로필 사진 변경 페이지 이동
            },
          ),

          const SizedBox(height: 20),

          // 알림 설정
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '알림 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),
          ListTile(
            title: const Text('푸시 알림 ON/OFF'),
            trailing: Switch(
              value: true,
              onChanged: null, // 여기에 상태관리 로직 넣기
            ),
          ),

          const SizedBox(height: 20),

          // 테마 설정
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '테마 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),
          ListTile(
            title: const Text('다크 모드'),
            trailing: Switch(
              value: false,
              onChanged: null, // 상태관리 연결하기
            ),
          ),

          const SizedBox(height: 20),

          // 보안 설정
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '보안 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),
          ListTile(
            title: const Text('생체 인증 사용'),
            trailing: Switch(
              value: true,
              onChanged: null,
            ),
          ),

          const SizedBox(height: 20),

          // AI 캐릭터 설정
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'AI 캐릭터 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),
          ListTile(
            title: const Text('채린 말투 조절'),
            onTap: () {
              // 말투 조절 페이지 이동
            },
          ),

          const SizedBox(height: 20),

          // 도움말 & 피드백
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '도움말 & 피드백',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),
          ListTile(
            title: const Text('FAQ'),
            onTap: () {
              // FAQ 페이지 이동
            },
          ),
          ListTile(
            title: const Text('문의하기'),
            onTap: () {
              // 문의하기 페이지 이동
            },
          ),

          const SizedBox(height: 20),

          // 앱 정보
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '앱 정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),
          ListTile(
            title: const Text('버전 정보'),
            onTap: () {
              // 버전 정보 페이지 이동
            },
          ),
          ListTile(
            title: const Text('개인정보처리방침'),
            onTap: () {
              // 개인정보처리방침 페이지 이동
            },
          ),

          const SizedBox(height: 20),

          // 로그아웃 & 계정 탈퇴
          const Divider(thickness: 1),
          ListTile(
          title: const Text(
            '로그아웃',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            // 로그인 화면으로 이동하면서 현재 화면 제거
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),

          ListTile(
            title: const Text(
              '계정 탈퇴',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // 계정 탈퇴 처리
            },
          ),
        ],
      ),
    );
  }
}
