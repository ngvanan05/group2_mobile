import 'dart:io';
import 'package:flutter/material.dart';
import '../../../features/post/models/post_model.dart';
import '../../../features/interaction/screens/comment_screen.dart';
import '../../../features/interaction/screens/likes_screen.dart';
import '../../../features/interaction/screens/share_sheet.dart';

export '../../../features/post/models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostData post;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.post,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _liked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Color(0xFF1565C0)),
              title: const Text('Chỉnh sửa bài viết'),
              onTap: () {
                Navigator.pop(context);
                widget.onEdit?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Xóa bài viết',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final avatarColor = Color(post.avatarColorValue);
    final badgeColor =
        post.badgeColorValue != null ? Color(post.badgeColorValue!) : null;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 22,
                child: Text(post.authorInitials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(post.authorName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        if (post.badge != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor ?? const Color(0xFF1976D2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(post.badge!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('${post.role} • ${post.timeAgo}',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.grey),
                onPressed: _showOptions,
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (post.emotion != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('${_emotionEmoji(post.emotion!)} Cảm thấy ${post.emotion}',
                  style: const TextStyle(
                      color: Color(0xFF1565C0), fontSize: 13)),
            ),

          Text(post.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(post.content,
              style: TextStyle(
                  color: Colors.grey[800], fontSize: 14, height: 1.5)),

          if (post.taggedUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Cùng với ${post.taggedUsers.map((u) => '@$u').join(', ')}',
                style: const TextStyle(
                    color: Color(0xFF1565C0), fontSize: 13),
              ),
            ),

          if (post.imagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImage(post.imagePath!),
              ),
            ),

          const SizedBox(height: 12),

          // Stats — bấm vào lượt thích để xem danh sách
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LikesScreen(totalLikes: _likes),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.thumb_up, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: 4),
                    Text('$_likes lượt thích',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CommentScreen(post: post)),
                ),
                child: Text(
                  '${post.comments} bình luận • ${post.shares} chia sẻ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: _liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: _liked ? 'Đã thích' : 'Thích',
                color: _liked ? Colors.blue : Colors.grey[700]!,
                onTap: () => setState(() {
                  _liked = !_liked;
                  _likes += _liked ? 1 : -1;
                }),
              ),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: 'Bình luận',
                color: Colors.grey[700]!,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CommentScreen(post: post)),
                ),
              ),
              _ActionButton(
                icon: Icons.reply_outlined,
                label: 'Chia sẻ',
                color: Colors.grey[700]!,
                onTap: () => showShareSheet(context, post,
                    onShared: () => setState(() {})),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(path,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink());
    }
    return Image.file(File(path),
        width: double.infinity, fit: BoxFit.cover);
  }

  String _emotionEmoji(String emotion) {
    const map = {
      'Vui vẻ': '😄',
      'Hạnh phúc': '😊',
      'Tuyệt vời': '🤩',
      'Biết ơn': '🙏',
      'Tự hào': '😎',
      'Bực mình': '😤',
      'Mệt mỏi': '😩',
      'Lo lắng': '😟',
      'Buồn': '😢',
      'Tức giận': '😡',
    };
    return map[emotion] ?? '😊';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
