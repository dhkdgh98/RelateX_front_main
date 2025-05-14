

// import 'package:flutter/material.dart';
// import 'record/photo_record_screen.dart';
// import 'record/text_record_screen.dart';
// import 'record/voice_record_screen.dart';
// import 'record/chatbot_record_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               // ? ����
//               const Text(
//                 'Relate X',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 20),

              
              

//               Stack(
//                     children: [
//                       // ���� �ڽ�
//                       Container(
//                         padding: const EdgeInsets.all(12), // ���� �ڽ� ���� ����
//                         decoration: BoxDecoration(
//                           color: Colors.white, // �ڽ� ��� ��
//                           borderRadius: BorderRadius.circular(20), // ���� �ڽ� �𼭸� �ձ۰�
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 10,
//                               offset: Offset(0, 4), // �׸��� ȿ��
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center, // ��� ����
//                           children: [
//                             _RecordOptionButton(
//                               icon: Icons.photo_camera,
//                               label: '',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const PhotoRecordScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(width: 16), // ��ư ���� ������ �ø��� ���� �߰�
//                             _RecordOptionButton(
//                               icon: Icons.edit,
//                               label: '',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const TextRecordScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(width: 16), // ��ư ���� ������ �ø��� ���� �߰�
//                             _RecordOptionButton(
//                               icon: Icons.mic,
//                               label: '',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const VoiceRecordScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(width: 16), // ��ư ���� ������ �ø��� ���� �߰�
//                             _RecordOptionButton(
//                               icon: Icons.chat_bubble_outline,
//                               label: '',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const ChatbotRecordScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
                      
//                       // ���� ��ܿ� 'RECORD'�� �����ư �̸���
//                       Positioned(
//                         right:15,
//                         bottom: 10,
//                         child: Row(
//                           children: [
//                             const Text(
//                               'RECORD',
//                               style: TextStyle(
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(width: 3),
//                             Icon(
//                               Icons.radio_button_on, // �����ư �̸��� ��� Flutter�� play �������� ���
//                               size: 10,
//                               color: const Color.fromARGB(255, 255, 0, 0),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),



//               const SizedBox(height: 20),


//               // ? ���� ��� �����ֱ�
             
//               const SizedBox(height: 12),

//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '2025.05.13',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '������ ������ �������� �����ߴ�. ������ ��ó�� �ൿ���� �ʰ� ������ ��� ��ȭ�Ϸ��� ����� ���̾���.',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),
//               const Text(
//                 '�� ���� ����� ���⿡ ���� �����̿��� ?',
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//               const SizedBox(height: 80), // ���� ����
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class _RecordOptionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _RecordOptionButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[300], // ��ư ��� ��
//               shape: BoxShape.circle, // �ձ� ��ư
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   offset: Offset(0, 4), // �׸��� ȿ��
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(8), // ���� ���� ����
//             child: Icon(
//               icon,
//               size: 36, // ������ ũ�� ����
//               color: Colors.black87, // ������ ����
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.black87, // �ؽ�Ʈ ����
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }