import 'package:flutter/material.dart';

class LikesScreen extends StatelessWidget {
  final int totalLikes;
  const LikesScreen({super.key, required this.totalLikes});

  static const List<Map<String, dynamic>> _likers = [
    {'name': 'Phạm Văn Tú', 'initials': 'PVT', 'color': 0xFF1565C0, 'role': 'Bộ phận Kỹ thuật'},
    {'name': 'Lê Thị Mai', 'initials': 'LTM', 'color': 0xFF8E24AA, 'role': 'Bộ phận Buồng phòng'},
    {'name': 'Nguyễn Văn Minh', 'initials': 'NM', 'color': 0xFFFF8F00, 'role': 'Quản lý Lễ tân'},
    {'name': 'Trần Lan', 'initials': 'TL', 'color': 0xFF43A047, 'role': 'Lễ tân'},
    {'name': 'Nguyễn Nhật Hạ', 'initials': 'NH', 'color': 0xFF00897B, 'role': 'Lễ tân'},
    {'name': 'Duy Khánh', 'initials': 'DK', 'color': 0xFF757575, 'role': 'Bộ phận Bếp'},
    {'name': 'Phan Thành', 'initials': 'PT', 'color': 0xFF7B1FA2, 'role': 'Bộ phận Bếp'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Người đã thích',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.thumb_up, color: Color(0xFF1565C0), size: 20),
                const SizedBox(width: 8),
                Text(
                  '$totalLikes lượt thích',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _likers.length,
              itemBuilder: (_, i) {
                final l = _likers[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(l['color'] as int),
                    child: Text(
                      l['initials'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                  title: Text(l['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(l['role'] as String,
                      style: TextStyle(
                          color: Colors.grey[500], fontSize: 12)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
