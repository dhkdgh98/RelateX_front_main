import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bottom_nav/view/bottom_nav_screen.dart';
import '../controller/auth_controller.dart';
import '../controller/auth_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
                // SizedBox(
                //   width: double.infinity, // 화면 너비에 맞게 버튼 크기
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // 로그인 기능을 구현할 곳
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(builder: (context) => const BottomNavScreen()),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.black,
                //       padding: const EdgeInsets.symmetric(vertical: 15.0),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //       ),
                //     ),
                //     child: const Text(
                //       '로그인',
                //       style: TextStyle(
                //         fontSize: 16,
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
// SizedBox(
//   width: double.infinity,
//   child: ElevatedButton(
//     onPressed: () async {
//       final username = _idController.text.trim();
//       final password = _passwordController.text.trim();

//       if (username.isEmpty || password.isEmpty) {
//         // 빈 칸이면 그냥 홈 화면으로 이동
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const BottomNavScreen()),
//         );
//       } else {
//         // 로그인 시도!
//         bool success = await AuthController.login(
//           username: username,
//           password: password,
//         );

//         if (success) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const BottomNavScreen()),
//           );
//         } else {
//           // 실패했을 때 알려주기!
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해 주세요.')),
//           );
//         }
//       }
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.black,
//       padding: const EdgeInsets.symmetric(vertical: 15.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//     ),
//     child: const Text(
//       '로그인',
//       style: TextStyle(
//         fontSize: 16,
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ),
// ),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {
      final username = _idController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        // 빈 칸이면 그냥 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),
        );
      } else {
        // 로그인 시도!
        String? userId = await AuthController.login(
          username: username,
          password: password,
        );

        if (userId != null) {
          // 로그인 성공! userId를 authProvider에 저장
          ref.read(authProvider.notifier).setUserId(userId);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavScreen()),
          );
        } else {
          // 실패했을 때 알려주기!
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해 주세요.')),
          );
        }
      }
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
                //     TextButton(
                //       onPressed: () {},
                //       child: const Text(
                //         '회원가입',
                //         style: TextStyle(color: Colors.black),
                //       ),
                //     ),
                //   ],
                // ),

                TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                            );
                          },
                          child: const Text(
                          '회원가입',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 반응형 높이

                

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'SNS 소셜 로그인',
                      style: TextStyle(
                      
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                    // Google 버튼
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/google.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Google로 시작하기',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Kakao 버튼
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEE500),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/kakaotalk.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Kakao로 시작하기',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Naver 버튼
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF03C75A),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/naver.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Naver로 시작하기',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

