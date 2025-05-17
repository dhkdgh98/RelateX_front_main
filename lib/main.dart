import 'package:flutter/material.dart';
import 'features/splash/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relate X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        // ✅ 기본 배경 색상
        scaffoldBackgroundColor: Colors.white,

        // ✅ AppBar 스타일
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        // ✅ 하단탭바 스타일
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),

        // ✅ 전체 텍스트 기본 색상
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),

        // ✅ 명시적 primary 색상 설정
        primaryColor: Colors.black,

        // ✅ ColorScheme 수동 설정 (seedColor 사용 안함)
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey,
        ),

        // ✅ 텍스트 버튼 기본 스타일
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        // ✅ 아이콘 색상 통일
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        // ✅ 체크박스 색상 통일
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStatePropertyAll(Colors.black),
          checkColor: MaterialStatePropertyAll(Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
