import 'package:flutter/material.dart';
import 'search_field.dart'; // ✅ 검색 필드 위젯
import 'calendar.dart';     // ✅ 캘린더 모달
import 'filter.dart';       // ✅ 필터 모달

class Buttons extends StatefulWidget {
  final VoidCallback onScrollToTop;
  final ValueChanged<String> onSearchChanged;
  final Function(DateTime?, DateTime?) onDateRangeSelected;

  const Buttons({
    super.key,
    required this.onScrollToTop,
    required this.onSearchChanged,
    required this.onDateRangeSelected,
  });

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearchChanged(_searchController.text);
  }

  void _openCalendarModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CalendarModal(
        onDateRangeSelected: widget.onDateRangeSelected,
      ),
    );
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ 상단 우측 버튼 or 검색 필드
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _isSearching
                  ? SearchField(
                      controller: _searchController,
                      onCancel: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                          widget.onSearchChanged(''); // 검색어 초기화
                        });
                      },
                    )
                  : _buildSmallIconButton(
                      icon: Icons.search,
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
              const SizedBox(height: 8),
              _buildSmallIconButton(
                icon: Icons.calendar_today,
                onPressed: _openCalendarModal,
              ),
              const SizedBox(height: 8),
              _buildSmallIconButton(
                icon: Icons.filter_alt,
                onPressed: _openFilterModal,
              ),
            ],
          ),
        ),

        // ✅ 하단 좌측 버튼 (스크롤 맨 위로)
        Positioned(
          bottom: 30,
          left: 20,
          child: FloatingActionButton(
            heroTag: 'scrollToTop',
            onPressed: widget.onScrollToTop,
            backgroundColor: Colors.white.withOpacity(0.9),
            foregroundColor: Colors.black87,
            mini: true,
            elevation: 3,
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        tooltip: icon.toString(),
      ),
    );
  }
}
