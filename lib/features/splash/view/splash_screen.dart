import 'package:flutter/material.dart';
import 'dart:async';
import '../../login/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Relate X', // 로고 텍스트
          style: TextStyle(
            fontFamily: 'CourierPrime',  // 로컬 폰트로 CourierPrime 지정
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black, // 로고 텍스트 색상
          ),
        ),
      ),
    );
  }
}
