import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post_model.dart';
import '../widgets/audience_picker.dart';
import '../widgets/emotion_picker.dart';

class CreatePostScreen extends StatefulWidget {
  final PostData? editPost;
  final PostData? sharedPost;

  const CreatePostScreen({super.key, this.editPost, this.sharedPost});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late final TextEditingController _contentController;
  late String _audience;
  EmotionOption? _emotion;
  File? _pickedImage;
  String? _existingImagePath;
  final List<String> _taggedUsers = [];
  bool get _isEdit => widget.editPost != null;

  // Danh sách user mẫu để tag
  final List<String> _allUsers = [
    'Nguyễn Thị Lan',
    'Phạm Văn Tú',
    'Lê Thị Mai',
    'Trần Văn Nam',
    'Hoàng Thị Hoa',
  ];

  @override
  void initState() {
    super.initState();
    final post = widget.editPost;
    _contentController = TextEditingController(
      text: post != null ? '${post.title}\n${post.content}' : '',
    );
    _audience = post?.audience ?? 'Toàn khách sạn';
    _existingImagePath = post?.imagePath;
    if (post?.emotion != null) {
      _emotion = kEmotions.firstWhere(
        (e) => e.label == post!.emotion,
        orElse: () => kEmotions.first,
      );
    }
    if (post != null) _taggedUsers.addAll(post.taggedUsers);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _existingImagePath = null;
      });
    }
  }

  void _showTagUserDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nhắc đến người dùng',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ..._allUsers.map((user) {
                final tagged = _taggedUsers.contains(user);
                return CheckboxListTile(
                  value: tagged,
                  title: Text(user),
                  activeColor: const Color(0xFF1565C0),
                  onChanged: (val) {
                    setModalState(() {
                      if (val == true) {
                        _taggedUsers.add(user);
                      } else {
                        _taggedUsers.remove(user);
                      }
                    });
                    setState(() {});
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    final text = _contentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung bài viết')),
      );
      return;
    }

    if (_isEdit) {
      // Hiện dialog xác nhận chỉnh sửa
      final confirmed = await _showConfirmDialog(
        icon: Icons.warning_amber_rounded,
        iconBgColor: const Color(0xFFFFF9C4),
        iconColor: const Color(0xFFF9A825),
        title: 'Xác nhận chỉnh sửa?',
        message:
            'Bạn có chắc chắn muốn chỉnh sửa bài viết này không? Hành động này không thể hoàn tác.',
        confirmLabel: 'Lưu',
        confirmColor: const Color(0xFF43A047),
      );
      if (!confirmed) return;
    }

    // Tách title / content từ text
    final lines = text.split('\n');
    final title = lines.first;
    final content = lines.length > 1 ? lines.skip(1).join('\n') : '';

    final result = PostData(
      id: widget.editPost?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'Nguyễn Văn Minh',
      authorInitials: 'NM',
      avatarColorValue: 0xFF1565C0,
      badge: 'Toàn khách sạn',
      badgeColorValue: 0xFF1976D2,
      role: 'Lễ tân',
      timeAgo: 'Vừa xong',
      title: title,
      content: content,
      likes: widget.editPost?.likes ?? 0,
      comments: widget.editPost?.comments ?? 0,
      shares: widget.editPost?.shares ?? 0,
      imagePath: _pickedImage?.path ?? _existingImagePath,
      emotion: _emotion?.label,
      audience: _audience,
      taggedUsers: List.from(_taggedUsers),
    );

    if (!mounted) return;
    Navigator.pop(context, result);
  }

  Future<bool> _showConfirmDialog({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(message,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14,
                      height: 1.5)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Hủy',
                        style: TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(confirmLabel,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
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
        title: Text(
          _isEdit ? 'Chỉnh sửa bài viết' : 'Tạo bài viết',
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 17),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
              child: Text(
                _isEdit ? 'Lưu' : 'Đăng',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author info
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF1565C0),
                        radius: 22,
                        child: Text('NM',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nguyễn Văn Minh',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          AudiencePicker(
                            selected: _audience,
                            onChanged: (v) =>
                                setState(() => _audience = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Emotion tag
                  if (_emotion != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            '${_emotion!.emoji} Cảm thấy ${_emotion!.label}',
                            style: const TextStyle(
                                color: Color(0xFF1565C0), fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _emotion = null),
                            child: const Icon(Icons.close,
                                size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                  // Tagged users
                  if (_taggedUsers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        spacing: 6,
                        children: _taggedUsers
                            .map((u) => Chip(
                                  label: Text('@$u',
                                      style: const TextStyle(fontSize: 12)),
                                  deleteIcon: const Icon(Icons.close,
                                      size: 14),
                                  onDeleted: () => setState(
                                      () => _taggedUsers.remove(u)),
                                  backgroundColor:
                                      const Color(0xFFE3F2FD),
                                  side: BorderSide.none,
                                ))
                            .toList(),
                      ),
                    ),

                  // Content input
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: _isEdit
                          ? 'Chỉnh sửa nội dung...'
                          : 'Bạn đang nghĩ gì, Minh?',
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: 16),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),

                  // Shared post preview
                  if (widget.sharedPost != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                              CircleAvatar(
                                backgroundColor: Color(widget.sharedPost!.avatarColorValue),
                                radius: 14,
                                child: Text(widget.sharedPost!.authorInitials,
                                    style: const TextStyle(color: Colors.white, fontSize: 10)),
                              ),
                              const SizedBox(width: 8),
                              Text(widget.sharedPost!.authorName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(widget.sharedPost!.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.sharedPost!.content.substring(0, widget.sharedPost!.content.length.clamp(0, 80))}...',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                  // Image preview
                  if (_pickedImage != null || _existingImagePath != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _pickedImage != null
                              ? Image.file(_pickedImage!,
                                  width: double.infinity,
                                  fit: BoxFit.cover)
                              : Image.network(
                                  _existingImagePath!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image,
                                        size: 48, color: Colors.grey),
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _pickedImage = null;
                              _existingImagePath = null;
                            }),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Bottom toolbar
          _buildBottomToolbar(),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toolbar row
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text('Thêm vào bài viết',
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 14)),
                const Spacer(),
                _ToolbarIcon(
                  icon: Icons.image,
                  color: const Color(0xFF43A047),
                  onTap: _pickImage,
                ),
                const SizedBox(width: 8),
                _ToolbarIcon(
                  icon: Icons.emoji_emotions_outlined,
                  color: const Color(0xFFFFA000),
                  onTap: () async {
                    final e = await showEmotionPicker(context);
                    if (e != null) setState(() => _emotion = e);
                  },
                ),
                const SizedBox(width: 8),
                _ToolbarIcon(
                  icon: Icons.more_horiz,
                  color: Colors.grey,
                  onTap: _showTagUserDialog,
                ),
              ],
            ),
          ),
          // Quick action buttons
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF43A047),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.image, color: Colors.white, size: 20),
            ),
            title: const Text('Ảnh/Video'),
            onTap: _pickImage,
            dense: true,
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text('😊', style: TextStyle(fontSize: 18)),
            ),
            title: const Text('Cảm xúc/Hoạt động'),
            onTap: () async {
              final e = await showEmotionPicker(context);
              if (e != null) setState(() => _emotion = e);
            },
            dense: true,
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.alternate_email,
                  color: Color(0xFF1565C0), size: 20),
            ),
            title: const Text('Nhắc đến người dùng'),
            onTap: _showTagUserDialog,
            dense: true,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ToolbarIcon(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 26),
    );
  }
}
