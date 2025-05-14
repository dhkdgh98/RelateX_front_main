


// import 'package:flutter/material.dart';
// import '../../home/view/home_screen.dart';

// class BottomNavScreen extends StatefulWidget {
//   const BottomNavScreen({super.key});

//   @override
//   State<BottomNavScreen> createState() => _BottomNavScreenState();
// }

// class _BottomNavScreenState extends State<BottomNavScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const Center(child: Text('Profile Screen')),
//     const Center(child: Text('Settings Screen')),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // ✅ 메인 scaffold (탭 & 화면)
//         Scaffold(
//           body: _screens[_currentIndex],
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _currentIndex,
//             onTap: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             type: BottomNavigationBarType.fixed,
//             showSelectedLabels: false,
//             showUnselectedLabels: false,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.settings),
//                 label: '',
//               ),
//             ],
//           ),
//         ),

        
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../home/view/home_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Profile Screen')),
    const Center(child: Text('Settings Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}

