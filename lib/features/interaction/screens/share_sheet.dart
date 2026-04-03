import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../features/post/models/post_model.dart';
import '../../../features/post/screens/create_post_screen.dart';

void showShareSheet(BuildContext context, PostData post,
    {VoidCallback? onShared}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _ShareSheet(post: post, onShared: onShared),
  );
}

class _ShareSheet extends StatelessWidget {
  final PostData post;
  final VoidCallback? onShared;

  const _ShareSheet({required this.post, this.onShared});

  static const List<Map<String, dynamic>> _suggestedUsers = [
    {'initials': 'PVT', 'name': 'Văn Tú', 'color': 0xFF1565C0},
    {'initials': 'LTM', 'name': 'Thị Mai', 'color': 0xFF8E24AA},
    {'initials': 'NM', 'name': 'Nhật Minh', 'color': 0xFFFF8F00},
    {'initials': 'HN', 'name': 'Hà Nam', 'color': 0xFF43A047},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chia sẻ bài viết',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Divider(),

          // Chia sẻ lên bảng tin
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.article_outlined,
                  color: Color(0xFF1565C0), size: 22),
            ),
            title: const Text('Chia sẻ lên bảng tin của tôi'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.pop(context);
              final nav = Navigator.of(context);
              nav.push(
                MaterialPageRoute(
                  builder: (_) => CreatePostScreen(sharedPost: post),
                ),
              ).then((result) {
                if (result != null) {
                  onShared?.call();
                  if (context.mounted) _showToast(context, 'Đã chia sẻ lên bảng tin');
                }
              });
            },
          ),

          // Gửi tin nhắn
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chat_bubble_outline,
                  color: Color(0xFF43A047), size: 22),
            ),
            title: const Text('Gửi dưới dạng tin nhắn'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.pop(context);
              _showSendMessageSheet(context, post);
            },
          ),

          // Sao chép liên kết
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.link, color: Colors.grey, size: 22),
            ),
            title: const Text('Sao chép liên kết'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.pop(context);
              Clipboard.setData(ClipboardData(
                  text: 'fourpoint://post/${post.id ?? "unknown"}'));
              _showToast(context, 'Đã sao chép liên kết');
            },
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('GỢI Ý NGƯỜI NHẬN',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _suggestedUsers.map((u) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showToast(context, 'Gửi tin nhắn thành công');
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(u['color'] as int),
                        radius: 24,
                        child: Text(u['initials'] as String,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ),
                      const SizedBox(height: 4),
                      Text(u['name'] as String,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

void _showSendMessageSheet(BuildContext context, PostData post) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _SendMessageSheet(post: post),
  );
}

class _SendMessageSheet extends StatefulWidget {
  final PostData post;
  const _SendMessageSheet({required this.post});

  @override
  State<_SendMessageSheet> createState() => _SendMessageSheetState();
}

class _SendMessageSheetState extends State<_SendMessageSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _msgCtrl = TextEditingController();
  final Set<int> _selected = {};

  static const List<Map<String, dynamic>> _contacts = [
    {'name': 'Phạm Văn Tú', 'initials': 'PVT', 'color': 0xFF1565C0, 'dept': 'Bộ phận Kỹ thuật'},
    {'name': 'Lê Thị Mai', 'initials': 'LTM', 'color': 0xFF8E24AA, 'dept': 'Bộ phận Buồng phòng'},
    {'name': 'Nguyễn Minh', 'initials': 'NM', 'color': 0xFFFF8F00, 'dept': 'Quản lý Lễ tân'},
    {'name': 'Hà Nam', 'initials': 'HN', 'color': 0xFF43A047, 'dept': 'Bộ phận Bếp'},
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (_, ctrl) => Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text('Gửi tin nhắn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextButton(
                  onPressed: _selected.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          _showToast(context, 'Gửi tin nhắn thành công');
                        },
                  child: Text('Gửi',
                      style: TextStyle(
                          color: _selected.isEmpty
                              ? Colors.grey
                              : const Color(0xFF1565C0),
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm người nhận...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('NGƯỜI NHẬN GẦN ĐÂY',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: ctrl,
              itemCount: _contacts.length,
              itemBuilder: (_, i) {
                final c = _contacts[i];
                final sel = _selected.contains(i);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(c['color'] as int),
                    child: Text(c['initials'] as String,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                  title: Text(c['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(c['dept'] as String,
                      style: TextStyle(
                          color: Colors.grey[500], fontSize: 12)),
                  trailing: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sel
                          ? const Color(0xFF1565C0)
                          : Colors.transparent,
                      border: Border.all(
                          color: sel
                              ? const Color(0xFF1565C0)
                              : Colors.grey[400]!),
                    ),
                    child: sel
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 14)
                        : null,
                  ),
                  onTap: () => setState(() {
                    if (sel) {
                      _selected.remove(i);
                    } else {
                      _selected.add(i);
                    }
                  }),
                );
              },
            ),
          ),
          // Post preview + message input
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.article_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.post.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          size: 16, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  'Bởi ${widget.post.authorName} • ${widget.post.role}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _selected.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          _showToast(context, 'Gửi tin nhắn thành công');
                        },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selected.isEmpty
                          ? Colors.grey[300]
                          : const Color(0xFF1565C0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (_) => Positioned(
      bottom: 80,
      left: 24,
      right: 24,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
              border: Border.all(color: const Color(0xFFB9F6CA)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF66BB6A),
                  radius: 12,
                  child: Icon(Icons.check, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 10),
                Text(message,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(width: 10),
                const Icon(Icons.close, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 2), entry.remove);
}
