import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view/friends_widgets/friends_card.dart';
import '../providers/friends_provider.dart';
import '../../auth/controller/auth_provider.dart';
import '../api/friends_api.dart';

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
  final Set<String> selectedFriends = {};
  String sortType = '이름순';

  // 모달 상태 관리
  bool isModalLoading = false;
  List<String> modalFriends = [];

  final List<String> allTags = ['친구', '가족', '학교', '동아리', '헬스메이트'];
  final List<String> allMbti = ['INFP', 'ESTJ', 'ENFP', 'INTJ']; // 예시
  final List<String> allInterests = ['영화', '운동', '산책', '독서'];

  // 친구 추가 폼 컨트롤러
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mbtiController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _interestsController = TextEditingController();
  final _tagsController = TextEditingController();

  // RecordOption 친구 목록
  List<String> recordOptionFriends = [];
  bool isLoadingRecordOptions = false;

  @override
  void initState() {
    super.initState();
    debugPrint('[DEBUG] 🏁 FriendsScreen 초기화');
    _loadRecordOptions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mbtiController.dispose();
    _birthdayController.dispose();
    _interestsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _handleRetry() {
    debugPrint('[DEBUG] 🔄 친구 목록 다시 시도');
    ref.invalidate(friendsProvider);
  }

  List<Map<String, dynamic>> _filterAndSortFriends(List<Map<String, dynamic>> friends) {
    debugPrint('[DEBUG] 🔄 필터링된 친구 목록 계산 중...');
    final filtered = friends.where((friend) {
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
    
    debugPrint('[DEBUG] ✅ 필터링 완료 - ${filtered.length}명의 친구');
    return filtered;
  }

  Widget _buildFilterChips(List<String> items, Set<String> selectedSet) {
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
            debugPrint('[DEBUG] 🏷️ 필터 변경: $item - ${value ? '선택' : '해제'}');
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

  Widget _buildFriendsList(List<Map<String, dynamic>> friends) {
    if (friends.isEmpty) {
      debugPrint('[DEBUG] 📭 필터링된 친구 없음');
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text('조건에 맞는 친구가 없어요 🥺'),
        ),
      );
    }

    debugPrint('[DEBUG] 👥 친구 목록 표시 - ${friends.length}명');
    return Column(
      children: friends.map((f) => FriendCard(
        name: f['name'],
        mbti: f['mbti'],
        birthday: f['birthday'],
        interests: List<String>.from(f['interests'] ?? []),
        tags: List<String>.from(f['tags'] ?? []),
        onEdit: () {
          debugPrint('[DEBUG] ✏️ 친구 정보 수정: ${f['name']}');
        },
        onDelete: () => _handleDeleteFriend(f),
      )).toList(),
    );
  }

  Future<void> _handleDeleteFriend(Map<String, dynamic> friend) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('친구 삭제'),
        content: Text('${friend['name']}님을 친구 목록에서 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        print('[DEBUG] 🗑️ 친구 삭제 시도: ${friend['name']}');
        await FriendsApi.deleteFriend(friend['_id']);
        print('[DEBUG] ✅ 친구 삭제 성공');

        // 친구 목록 새로고침
        ref.invalidate(friendsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('친구가 삭제되었습니다'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('[ERROR] 🧨 친구 삭제 중 오류 발생: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('친구 삭제에 실패했습니다: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _loadRecordOptions() async {
    print('[DEBUG] 🚀 RecordOption 로딩 시작');
    setState(() {
      isModalLoading = true;
      modalFriends = [];
    });

    try {
      print('[DEBUG] 📥 RecordOption API 호출 시작');
      final recordOptions = await FriendsApi.getRecordOptions('wangho98');
      print('[DEBUG] 📦 RecordOption API 응답 수신: $recordOptions');
      
      if (recordOptions != null && recordOptions['friends'] != null) {
        setState(() {
          modalFriends = List<String>.from(recordOptions['friends']);
          print('[DEBUG] ✅ RecordOption 친구 목록 설정: $modalFriends');
        });
      } else {
        print('[DEBUG] ⚠️ RecordOption friends 배열이 없습니다');
        setState(() {
          modalFriends = [];
        });
      }
    } catch (e, stackTrace) {
      print('[ERROR] 🧨 RecordOption 로딩 중 오류 발생: $e');
      print('[ERROR] 📚 스택 트레이스: $stackTrace');
      setState(() {
        modalFriends = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('친구 목록을 불러오는데 실패했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isModalLoading = false;
        print('[DEBUG] 🏁 RecordOption 로딩 완료');
      });
    }
  }

  void _showAddFriendModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '친구 추가',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: '이름',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '이름을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '친구 기록과 연동하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isModalLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (modalFriends.isEmpty)
                            const Text('등록된 친구가 없습니다')
                          else
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: modalFriends.map((friend) {
                                  final isSelected = selectedFriends.contains(friend);
                                  return ChoiceChip(
                                    label: Text(
                                      friend,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setModalState(() {
                                        if (selected) {
                                          selectedFriends.add(friend);
                                        } else {
                                          selectedFriends.remove(friend);
                                        }
                                      });
                                    },
                                    selectedColor: Colors.deepPurple,
                                    backgroundColor: Colors.grey.shade100,
                                  );
                                }).toList(),
                              ),
                            ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _mbtiController,
                            decoration: const InputDecoration(
                              labelText: 'MBTI',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'MBTI를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _birthdayController,
                            decoration: const InputDecoration(
                              labelText: '생일 (YYYY-MM-DD)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '생일을 입력해주세요';
                              }
                              // 날짜 형식 검증
                              final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                              if (!dateRegex.hasMatch(value)) {
                                return 'YYYY-MM-DD 형식으로 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _interestsController,
                            decoration: const InputDecoration(
                              labelText: '관심사 (쉼표로 구분)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '관심사를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _tagsController,
                            decoration: const InputDecoration(
                              labelText: '태그 (쉼표로 구분)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '태그를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleAddFriend,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text(
                        '친구 추가하기',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddFriend() async {
    if (_formKey.currentState!.validate()) {
      try {
        final interests = _interestsController.text.split(',').map((e) => e.trim()).toList();
        final tags = _tagsController.text.split(',').map((e) => e.trim()).toList();

        print('[DEBUG] 📝 친구 추가 시도:');
        print('[DEBUG] 👤 이름: ${_nameController.text}');
        print('[DEBUG] 🎭 MBTI: ${_mbtiController.text}');
        print('[DEBUG] 🎂 생일: ${_birthdayController.text}');
        print('[DEBUG] 🎯 관심사: $interests');
        print('[DEBUG] 🏷️ 태그: $tags');

        await FriendsApi.addFriend(
          userId: 'wangho98', // TODO: 실제 사용자 ID로 변경
          name: _nameController.text,
          mbti: _mbtiController.text,
          birthday: _birthdayController.text,
          interests: interests,
          tags: tags,
        );

        print('[DEBUG] ✅ 친구 추가 성공');
        
        // 입력 필드 초기화
        _nameController.clear();
        _mbtiController.clear();
        _birthdayController.clear();
        _interestsController.clear();
        _tagsController.clear();

        // 모달 닫기
        Navigator.of(context).pop();

        // 친구 목록 새로고침
        ref.invalidate(friendsProvider);
      } catch (e) {
        print('[ERROR] 🧨 친구 추가 중 오류 발생: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('친구 추가에 실패했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
}

@override
Widget build(BuildContext context) {
    debugPrint('[DEBUG] 🎨 FriendsScreen 빌드 시작');
    final friendsAsync = ref.watch(friendsProvider);

  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '친구목록',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add_alt_1),
                    onPressed: _showAddFriendModal,
                )
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: TextButton.icon(
  onPressed: () {
                              debugPrint('[DEBUG] 🔍 필터 ${isFilterOpen ? '닫기' : '열기'}');
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                  if (isFilterOpen) ...[
                    const SizedBox(height: 8),
                    const Text('카테고리'),
                      _buildFilterChips(allTags, selectedTags),
                    const SizedBox(height: 12),
                    const Text('MBTI'),
                      _buildFilterChips(allMbti, selectedMbti),
                    const SizedBox(height: 12),
                    const Text('관심사'),
                      _buildFilterChips(allInterests, selectedInterests),
                    const SizedBox(height: 12),
                  ],

                    const SizedBox(height: 5),
                    
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
                              debugPrint('[DEBUG] 📊 정렬 방식 변경: $label');
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

                    friendsAsync.when(
                      loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Column(
                            children: [
                              Text(error.toString()),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _handleRetry,
                                child: const Text('다시 시도'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      data: (friends) => _buildFriendsList(_filterAndSortFriends(friends)),
                    ),
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