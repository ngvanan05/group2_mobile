import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/comment_model.dart';

class CommentTile extends StatefulWidget {
  final CommentModel comment;
  final bool isReply;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CommentTile({
    super.key,
    required this.comment,
    this.isReply = false,
    this.onReply,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late bool _liked;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _liked = widget.comment.liked;
    _likes = widget.comment.likes;
  }

  void _showOptions() {
    final isOwn = widget.comment.isOwner;
    final isPostOwner = widget.comment.isPostOwner;

    // Bình luận của mình: Sao chép, Chỉnh sửa, Xóa
    // Bình luận người khác: Sao chép, Trả lời, Xóa (chỉ khi là chủ bài viết)
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
            // Sao chép — luôn hiện
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Sao chép'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(
                    ClipboardData(text: widget.comment.content));
                _showToast(context, 'Sao chép thành công');
              },
            ),

            // Trả lời — luôn hiện (cả bình luận của mình lẫn người khác)
            ListTile(
              leading: const Icon(Icons.reply_outlined),
              title: const Text('Trả lời'),
              onTap: () {
                Navigator.pop(context);
                widget.onReply?.call();
              },
            ),

            // Chỉnh sửa — chỉ hiện với bình luận của mình
            if (isOwn)
              ListTile(
                leading: const Icon(Icons.edit_outlined,
                    color: Color(0xFF1565C0)),
                title: const Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onEdit?.call();
                },
              ),

            // Xóa — hiện với bình luận của mình HOẶC chủ bài viết xóa bình luận người khác
            if (isOwn || (!isOwn && isPostOwner))
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Xóa',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Xóa bình luận này?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy',
                style: TextStyle(color: Color(0xFF1565C0))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.onDelete?.call();
      if (mounted) _showToast(context, 'Xóa bình luận thành công');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.comment;
    return Padding(
      padding: EdgeInsets.only(
          left: widget.isReply ? 48 : 0, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Color(c.avatarColorValue),
            radius: widget.isReply ? 16 : 20,
            child: Text(
              c.authorInitials,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.isReply ? 10 : 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: _showOptions,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(c.authorName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                            const Spacer(),
                            Text(c.timeAgo,
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(c.content,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        _liked = !_liked;
                        _likes += _liked ? 1 : -1;
                      }),
                      child: Text(
                        _liked ? 'Đã thích' : 'Thích',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _liked
                              ? const Color(0xFF1565C0)
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    if (_likes > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.thumb_up,
                                size: 10, color: Colors.white),
                            const SizedBox(width: 2),
                            Text('$_likes',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                    // Trả lời — hiện với tất cả bình luận (kể cả reply)
                    GestureDetector(
                      onTap: widget.onReply,
                      child: Text(
                        'Trả lời',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600]),
                      ),
                    ),
                  ],
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
                  child:
                      Icon(Icons.check, color: Colors.white, size: 14),
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
