
// import 'package:flutter/material.dart';
// import 'features/splash/view/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//         ),
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: Colors.white,
//           selectedItemColor: Colors.blue,
//           unselectedItemColor: Colors.grey,
//         ),
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

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
        scaffoldBackgroundColor: Colors.white, // 전체 배경 흰색
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,        // 하단탭 배경 흰색
          selectedItemColor: Colors.black,      // 선택된 아이콘은 블랙
          unselectedItemColor: Colors.grey,     // 선택 안 된 아이콘은 그레이
          showSelectedLabels: false,            // 선택된 아이콘 라벨 안 보이게
          showUnselectedLabels: false,          // 안 된 것도 안 보이게
          type: BottomNavigationBarType.fixed,  // 아이콘 위치 고정
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // 전체 텍스트 블랙
          bodyMedium: TextStyle(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

