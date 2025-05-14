

import 'package:flutter/material.dart';
import '../../bottom_nav/view/bottom_nav_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 로그인 텍스트 라벨
                Text(
  'Relate X',
  style: TextStyle(
    fontFamily: 'CourierPrime',
    fontSize: 28,
    fontWeight: FontWeight.normal,  // 이 부분 추가
    fontStyle: FontStyle.normal,   // 이 부분 추가
    color: Colors.black,
  ),
),


                SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 반응형 높이

                // 아이디 텍스트 필드
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 반응형 높이

                // 비밀번호 텍스트 필드
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 반응형 높이

                // 로그인 버튼
                SizedBox(
                  width: double.infinity, // 화면 너비에 맞게 버튼 크기
                  child: ElevatedButton(
                    onPressed: () {
                      // 로그인 기능을 구현할 곳
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavScreen()),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 반응형 높이

                // 아이디 찾기 | 비밀번호 찾기 | 회원가입
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '아이디 찾기  ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '비밀번호 찾기',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '회원가입',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 반응형 높이

                // SNS 소셜 로그인 텍스트 라벨
                Text(
                  'SNS 소셜 로그인',
                  style: TextStyle(
                    fontFamily: 'RobotoMono', // 로컬 폰트 적용
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 반응형 높이

                // SNS 로그인 버튼들 (카카오톡, 구글, 네이버)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 카카오톡 버튼
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade800,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          '카카오톡',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 구글 버튼
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          '구글',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 네이버 버튼
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          '네이버',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

