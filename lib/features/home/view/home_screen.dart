

import 'package:flutter/material.dart';
import 'record/photo_record_screen.dart';
import 'record/text_record_screen.dart';
import 'record/voice_record_screen.dart';
import 'record/chatbot_record_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 📝 제목
              const Text(
                'Relate X',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              
              

              Stack(
                    children: [
                      // 라운드 박스
                      Container(
                        padding: const EdgeInsets.all(12), // 라운드 박스 안쪽 여백
                        decoration: BoxDecoration(
                          color: Colors.white, // 박스 배경 색
                          borderRadius: BorderRadius.circular(20), // 라운드 박스 모서리 둥글게
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4), // 그림자 효과
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                          children: [
                            _RecordOptionButton(
                              icon: Icons.photo_camera,
                              label: '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PhotoRecordScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16), // 버튼 사이 간격을 늘리기 위해 추가
                            _RecordOptionButton(
                              icon: Icons.edit,
                              label: '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TextRecordScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16), // 버튼 사이 간격을 늘리기 위해 추가
                            _RecordOptionButton(
                              icon: Icons.mic,
                              label: '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const VoiceRecordScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16), // 버튼 사이 간격을 늘리기 위해 추가
                            _RecordOptionButton(
                              icon: Icons.chat_bubble_outline,
                              label: '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChatbotRecordScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // 우측 상단에 'RECORD'와 재생버튼 이모지
                      Positioned(
                        right:15,
                        bottom: 10,
                        child: Row(
                          children: [
                            const Text(
                              'RECORD',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.radio_button_on, // 재생버튼 이모지 대신 Flutter의 play 아이콘을 사용
                              size: 10,
                              color: const Color.fromARGB(255, 255, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),



              const SizedBox(height: 20),


              // 📘 지난 기록 보여주기
             
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2025.05.13',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '오늘은 민지랑 오랜만에 연락했다. 예전의 나처럼 행동하지 않고 진심을 담아 대화하려고 노력한 날이었다.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                '더 많은 기록이 여기에 쌓일 예정이에요 ✨',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 80), // 여유 공간
            ],
          ),
        ),
      ),
    );
  }
}


class _RecordOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RecordOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300], // 버튼 배경 색
              shape: BoxShape.circle, // 둥근 버튼
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4), // 그림자 효과
                ),
              ],
            ),
            padding: const EdgeInsets.all(8), // 내부 여백 조정
            child: Icon(
              icon,
              size: 36, // 아이콘 크기 조정
              color: Colors.black87, // 아이콘 색상
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87, // 텍스트 색상
            ),
          ),
        ],
      ),
    );
  }
}
