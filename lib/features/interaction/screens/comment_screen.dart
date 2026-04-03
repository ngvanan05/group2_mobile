import 'package:flutter/material.dart';
import '../../../features/post/models/post_model.dart';
import '../models/comment_model.dart';
import '../widgets/comment_tile.dart';

class CommentScreen extends StatefulWidget {
  final PostData post;
  const CommentScreen({super.key, required this.post});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  CommentModel? _replyingTo;

  final List<CommentModel> _comments = [
    CommentModel(
      id: '1',
      authorName: 'Trần Lê Mai',
      authorInitials: 'TLM',
      avatarColorValue: 0xFF00897B,
      content: 'Em sẽ có mặt đúng giờ ạ. Cảm ơn anh đã thông báo!',
      timeAgo: '1 giờ trước',
      isPostOwner: true,
      likes: 0,
    ),
    CommentModel(
      id: '2',
      authorName: 'Phạm Văn Tú',
      authorInitials: 'PVT',
      avatarColorValue: 0xFF1565C0,
      content: 'Quy trình này áp dụng cho cả ca đêm luôn đúng không anh Minh?',
      timeAgo: '45 phút trước',
      isPostOwner: true,
      likes: 0,
      replies: [
        CommentModel(
          id: '2r1',
          authorName: 'Nguyễn Văn Minh',
          authorInitials: 'NVM',
          avatarColorValue: 0xFF37474F,
          content: '@Phạm Văn Tú Đúng rồi em nhé, áp dụng cho tất cả các ca.',
          timeAgo: '30 phút trước',
          isOwner: true,
          isPostOwner: true,
          likes: 0,
        ),
      ],
    ),
    CommentModel(
      id: '3',
      authorName: 'Lê Thị Mai',
      authorInitials: 'LTM',
      avatarColorValue: 0xFF8E24AA,
      content: 'Rất mong chờ quy trình mới này giúp tiết kiệm thời gian cho khách hàng.',
      timeAgo: '15 phút trước',
      isPostOwner: true,
      likes: 0,
    ),
    CommentModel(
      id: '4',
      authorName: 'Nguyễn Văn Minh',
      authorInitials: 'NM',
      avatarColorValue: 0xFF37474F,
      content: 'Quy trình này rất rõ ràng, cảm ơn bộ phận lễ tân!',
      timeAgo: 'Vừa xong',
      isOwner: true,
      isPostOwner: true,
      likes: 0,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'Nguyễn Văn Minh',
      authorInitials: 'NM',
      avatarColorValue: 0xFF37474F,
      content: _replyingTo != null ? '@${_replyingTo!.authorName} $text' : text,
      timeAgo: 'Vừa xong',
      isOwner: true,
      isPostOwner: true,
    );

    setState(() {
      if (_replyingTo != null) {
        final idx = _comments.indexWhere((c) => c.id == _replyingTo!.id);
        if (idx != -1) {
          _comments[idx].replies.add(newComment);
        }
      } else {
        _comments.add(newComment);
      }
      _replyingTo = null;
      _controller.clear();
    });
    _focusNode.unfocus();
  }

  void _deleteComment(String id, {String? parentId}) {
    setState(() {
      if (parentId != null) {
        final parent = _comments.firstWhere((c) => c.id == parentId);
        parent.replies.removeWhere((r) => r.id == id);
      } else {
        _comments.removeWhere((c) => c.id == id);
      }
    });
  }

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
          'Bình luận',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('BÌNH LUẬN',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1)),
                const SizedBox(height: 12),
                ..._comments.map((c) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommentTile(
                          comment: c,
                          onReply: () {
                            setState(() => _replyingTo = c);
                            _focusNode.requestFocus();
                          },
                          onDelete: () => _deleteComment(c.id),
                          onEdit: () => _showEditDialog(c),
                        ),
                        ...c.replies.map((r) => CommentTile(
                              comment: r,
                              isReply: true,
                              onReply: () {
                                // Trả lời reply → vẫn reply vào comment cha
                                setState(() => _replyingTo = c);
                                _focusNode.requestFocus();
                              },
                              onDelete: () =>
                                  _deleteComment(r.id, parentId: c.id),
                              onEdit: () => _showEditDialog(r),
                            )),
                        const SizedBox(height: 8),
                      ],
                    )),
              ],
            ),
          ),

          // Reply indicator
          if (_replyingTo != null)
            Container(
              color: Colors.grey[100],
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Đang trả lời ${_replyingTo!.authorName}',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF1565C0)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _replyingTo = null),
                    child: const Icon(Icons.close,
                        size: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),

          // Input bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey[200]!)),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF37474F),
                  radius: 18,
                  child: Text('NM',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Viết bình luận...',
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.emoji_emotions_outlined,
                            color: Colors.grey[400]),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _submitComment,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1565C0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(CommentModel comment) async {
    final ctrl = TextEditingController(text: comment.content);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        title: const Text('Chỉnh sửa bình luận'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0)),
            child: const Text('Lưu',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => comment.content = result);
    }
  }
}
