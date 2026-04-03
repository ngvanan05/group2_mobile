import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/new_message_sheet.dart';
import 'call_screen.dart';
import '../../../core/constants/app_constants.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String? userAvatar;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.userName,
    this.userAvatar,
    this.isOnline = false,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  // The message currently being edited (null = normal send mode)
  MessageModel? _editingMessage;

  final List<MessageModel> _messages = [
    MessageModel(
      id: '1',
      content: 'Chào anh, em đã kiểm tra lịch trình ngày mai cho đoàn khách 20 người rồi ạ. Mọi thứ đã sẵn sàng.',
      isMine: false,
      time: DateTime(2026, 3, 27, 14, 30),
    ),
    MessageModel(
      id: '2',
      content: 'Về 2 phòng VIP đặt trước, em nhớ phối hợp với bộ phận kỹ thuật.',
      isMine: true,
      time: DateTime(2026, 3, 27, 14, 35),
    ),
  ];

  // ── Scroll ──────────────────────────────────────────────────────────────────
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Send ────────────────────────────────────────────────────────────────────
  void _handleSend(String text) {
    setState(() {
      _messages.add(MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        isMine: true,
        time: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  // ── Edit ────────────────────────────────────────────────────────────────────
  void _handleEdit(MessageModel msg) {
    setState(() => _editingMessage = msg);
  }

  void _handleEditConfirm(String newText) {
    if (_editingMessage == null) return;
    final id = _editingMessage!.id;
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == id);
      if (idx != -1) {
        _messages[idx] =
            _messages[idx].copyWith(content: newText, isEdited: true);
      }
      _editingMessage = null;
    });
    _showToast('Tin nhắn đã được chỉnh sửa');
  }

  void _handleEditCancel() {
    setState(() => _editingMessage = null);
  }

  // ── Delete ──────────────────────────────────────────────────────────────────
  void _handleDelete(MessageModel msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.m),
            // Icon thùng rác
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline,
                  color: AppColors.error, size: 32),
            ),
            const SizedBox(height: AppSpacing.m),
            const Text(
              'Xóa tin nhắn?',
              style: TextStyle(
                fontSize: AppTextSize.subtitle,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            const Divider(height: 1, color: AppColors.divider),
            // Xóa cho mọi người
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteForAll(msg);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.m + 4),
                child: Center(
                  child: Text(
                    'Xóa cho mọi người',
                    style: TextStyle(
                      fontSize: AppTextSize.body,
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            // Xóa cho tôi
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteForMe(msg);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.m + 4),
                child: Center(
                  child: Text(
                    'Xóa cho tôi',
                    style: TextStyle(
                      fontSize: AppTextSize.body,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            // Hủy
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.m + 4),
                child: Center(
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                      fontSize: AppTextSize.body,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + AppSpacing.s),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteForAll(MessageModel msg) {
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) {
        _messages[idx] = msg.copyWith(status: MessageStatus.recalled);
      }
    });
    _showToast('Xóa thành công');
  }

  void _confirmDeleteForMe(MessageModel msg) {
    setState(() => _messages.removeWhere((m) => m.id == msg.id));
    _showToast('Xóa thành công');
  }

  // ── Recall ──────────────────────────────────────────────────────────────────
  void _handleRecall(MessageModel msg) {
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) {
        _messages[idx] = msg.copyWith(status: MessageStatus.recalled);
      }
    });
    _showToast('Thu hồi thành công', showUndo: true, onUndo: () {
      setState(() {
        final idx = _messages.indexWhere((m) => m.id == msg.id);
        if (idx != -1) {
          _messages[idx] = msg.copyWith(status: MessageStatus.normal);
        }
      });
    });
  }

  // ── Toast ───────────────────────────────────────────────────────────────────
  void _showToast(String message,
      {bool showUndo = false, VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1E2E),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.only(
          bottom: 80,
          left: AppSpacing.l,
          right: AppSpacing.l,
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            const Icon(Icons.check_circle,
                color: AppColors.success, size: 20),
            const SizedBox(width: AppSpacing.s),
            Text(message,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppTextSize.caption)),
          ],
        ),
        action: showUndo && onUndo != null
            ? SnackBarAction(
                label: 'Hoàn tác',
                textColor: Colors.white,
                onPressed: onUndo,
              )
            : null,
      ),
    );
  }

  // ── New message sheet ────────────────────────────────────────────────────────
  void _showNewMessageSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewMessageSheet(
        onContactSelected: (name) {
          // Navigate to a new chat with that contact
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailScreen(
                userName: name,
                isOnline: true,
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Call ─────────────────────────────────────────────────────────────────────
  void _handleCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          userName: widget.userName,
          avatarUrl: widget.userAvatar,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: AppSpacing.m),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildDateHeader('HÔM NAY, 14:30');
                final msg = _messages[index - 1];
                return ChatBubble(
                  message: msg,
                  avatarUrl: widget.userAvatar,
                  onDelete: _handleDelete,
                  onRecall: _handleRecall,
                  onEdit: _handleEdit,
                  onCopied: () => _showToast('Sao chép thành công'),
                );
              },
            ),
          ),
          ChatInputBar(
            onSend: _handleSend,
            onAddPressed: _showNewMessageSheet,
            editingText: _editingMessage?.content,
            onEditConfirm: _handleEditConfirm,
            onEditCancel: _handleEditCancel,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: widget.userAvatar != null
                ? NetworkImage(widget.userAvatar!)
                : null,
            backgroundColor: AppColors.border,
            child: widget.userAvatar == null
                ? const Icon(Icons.person, color: AppColors.textSecondary)
                : null,
          ),
          const SizedBox(width: AppSpacing.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppTextSize.subtitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.isOnline
                          ? AppColors.success
                          : AppColors.textHint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.isOnline ? 'Active now' : 'Offline',
                    style: const TextStyle(
                      fontSize: AppTextSize.small,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call_outlined, color: AppColors.textPrimary),
          onPressed: _handleCall, // ← wired
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDateHeader(String label) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: AppTextSize.small,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
