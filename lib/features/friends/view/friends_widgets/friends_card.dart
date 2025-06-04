import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  final String name;
  final String mbti;
  final String birthday;
  final List<String> interests;
  final List<String> tags;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEventTap;

  const FriendCard({
    super.key,
    required this.name,
    required this.mbti,
    required this.birthday,
    required this.interests,
    required this.tags,
    this.onEdit,
    this.onDelete,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 1,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧸 이름 + 관계 태그 Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: tags
                            .map((tag) => _buildMetaTag('🏷️', tag, const Color(0xFFFFE0B5)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 💫 나머지 메타 태그들
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildMetaTag('🎂', birthday, const Color(0xFFFFD1DC)),
                    _buildMetaTag('', mbti, const Color(0xFFB4D2FF)),
                    ...interests.map((interest) =>
                        _buildMetaTag('✨', interest, const Color(0xFFC8FACC))),
                  ],
                ),
              ],
            ),
          ),
        ),
        // ⏳ 이벤트 버튼
        Positioned(
          top: 10,
          right: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: onEventTap,
              icon: const Icon(Icons.event, size: 20, color: Colors.black),
              tooltip: '함께한 이벤트 보기',
              splashRadius: 20,
            ),
          ),
        ),
        // ⋮ 점 세 개 버튼
        Positioned(
          top: 4,
          right: 10,
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit?.call();
              } else if (value == 'delete') {
                onDelete?.call();
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('수정'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('삭제'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, size: 20),
            tooltip: '더보기',
          ),
        ),
      ],
    );
  }

  Widget _buildMetaTag(String emoji, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        '$emoji $label',
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: Colors.black87,

          
        ),
      ),
    );
  }
}

