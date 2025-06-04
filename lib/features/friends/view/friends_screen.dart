import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view/friends_widgets/friends_card.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  bool isFilterOpen = false;
  final Set<String> selectedTags = {};
  final Set<String> selectedMbti = {};
  final Set<String> selectedInterests = {};
  String sortType = '이름순';

  final List<String> allTags = ['친구', '가족', '학교', '동아리', '헬스메이트'];
  final List<String> allMbti = ['INFP', 'ESTJ', 'ENFP', 'INTJ']; // 예시
  final List<String> allInterests = ['영화', '운동', '산책', '독서'];

  final List<Map<String, dynamic>> friends = [
    {
      'name': '김예린',
      'mbti': 'INFP',
      'birthday': '04.15',
      'interests': ['영화'],
      'tags': ['친구', '동아리'],
    },
    {
      'name': '이정우',
      'mbti': 'ESTJ',
      'birthday': '11.30',
      'interests': ['운동'],
      'tags': ['가족', '헬스메이트'],
    },
    {
      'name': '박수진',
      'mbti': 'ENFP',
      'birthday': '08.07',
      'interests': ['산책', '독서'],
      'tags': ['학교'],
    },
  ];

  List<Map<String, dynamic>> get filteredFriends {
    return friends.where((friend) {
      bool matchesTags = selectedTags.isEmpty ||
          selectedTags.any((tag) => friend['tags'].contains(tag));
      bool matchesMbti =
          selectedMbti.isEmpty || selectedMbti.contains(friend['mbti']);
      bool matchesInterest = selectedInterests.isEmpty ||
          selectedInterests.any((i) => friend['interests'].contains(i));

      return matchesTags && matchesMbti && matchesInterest;
    }).toList()
      ..sort((a, b) {
        if (sortType == '이름순') {
          return a['name'].compareTo(b['name']);
        } else if (sortType == '생일순') {
          return a['birthday'].compareTo(b['birthday']);
        }
        return 0;
      });
  }

  Widget buildFilterChips(List<String> items, Set<String> selectedSet) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: items.map((item) {
      final selected = selectedSet.contains(item);
      return ChoiceChip(
        label: Text(
          item,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Colors.black54,
          ),
        ),
        selected: selected,
        onSelected: (value) {
          setState(() {
            if (value) {
              selectedSet.add(item);
            } else {
              selectedSet.remove(item);
            }
          });
        },
        selectedColor: Colors.deepPurple,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      );
    }).toList(),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // 헤더는 상단에 고정
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '친구목록',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add_alt_1),
                  onPressed: () {
                    // 친구 추가 로직
                  },
                )
              ],
            ),
            const SizedBox(height: 8),

            // 👇 필터 + 정렬 + 리스트는 한 스크롤 안에 들어감
            Expanded(
              child: ListView(
                children: [
                  // 🔽 필터 열기/닫기
                  // 🔽 필터 열기/닫기 버튼
TextButton.icon(
  onPressed: () {
    setState(() {
      isFilterOpen = !isFilterOpen;
    });
  },
  icon: Icon(
    isFilterOpen ? Icons.expand_less : Icons.expand_more,
    size: 20,
    color: Colors.black.withOpacity(0.8),
  ),
  label: const Text(
    'Filter',
    style: TextStyle(
      color: Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  style: TextButton.styleFrom(
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),


                  if (isFilterOpen) ...[
                    const SizedBox(height: 8),
                    const Text('카테고리'),
                    buildFilterChips(allTags, selectedTags),
                    const SizedBox(height: 12),
                    const Text('MBTI'),
                    buildFilterChips(allMbti, selectedMbti),
                    const SizedBox(height: 12),
                    const Text('관심사'),
                    buildFilterChips(allInterests, selectedInterests),
                    const SizedBox(height: 12),
                  ],

                  // 🔽 정렬 버튼
                 // 🔽 정렬 버튼 (이름순 / 생일순)
Row(
  children: ['이름순', '생일순'].map((label) {
    final isSelected = sortType == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color.fromARGB(221, 0, 0, 0),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() => sortType = label);
        },
        selectedColor: const Color.fromARGB(255, 171, 171, 171),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: isSelected ? 2 : 0,
        shadowColor: const Color.fromARGB(66, 194, 191, 191),
        side: isSelected
            ? BorderSide.none
            : const BorderSide(color: Colors.grey),
      ),
    );
  }).toList(),
),

                  const SizedBox(height: 16),

                  // 👥 친구 리스트
                  if (filteredFriends.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text('조건에 맞는 친구가 없어요 🥺'),
                      ),
                    )
                  else
                    ...filteredFriends.map((f) => FriendCard(
                          name: f['name'],
                          mbti: f['mbti'],
                          birthday: f['birthday'],
                          interests: List<String>.from(f['interests'] ?? []),
                          tags: List<String>.from(f['tags'] ?? []),
                          onEdit: () {},
                          onDelete: () {},
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}