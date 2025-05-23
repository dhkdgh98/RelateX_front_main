import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/splash/view/splash_screen.dart';
import 'features/auth/view/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relate X',
      debugShowCheckedModeBanner: false,

      routes: {
    '/login': (context) => const LoginScreen(), // 이걸 해야 '/login'으로 이동 가능
  },

      
    

      // ✅ 날짜 로컬라이제이션을 위한 설정 추가
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),

        primaryColor: Colors.black,

        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey,
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStatePropertyAll(Colors.black),
          checkColor: MaterialStatePropertyAll(Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
