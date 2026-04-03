import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String message) onSend;
  final void Function()? onAddPressed;

  /// When non-null, the bar enters "edit mode"
  final String? editingText;
  final void Function(String newText)? onEditConfirm;
  final void Function()? onEditCancel;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.onAddPressed,
    this.editingText,
    this.onEditConfirm,
    this.onEditCancel,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editingText != null) {
      _controller.text = widget.editingText!;
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  void didUpdateWidget(ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingText != null &&
        widget.editingText != oldWidget.editingText) {
      _controller.text = widget.editingText!;
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
    if (widget.editingText == null && oldWidget.editingText != null) {
      _controller.clear();
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (widget.editingText != null) {
      widget.onEditConfirm?.call(text);
    } else {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingText != null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          // Left button: cancel (edit mode) or add
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.error),
              onPressed: widget.onEditCancel,
            )
          else
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: AppColors.textSecondary),
              onPressed: widget.onAddPressed,
            ),

          // Text field
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                autofocus: isEditing,
                decoration: InputDecoration(
                  hintText:
                      isEditing ? 'Chỉnh sửa tin nhắn...' : 'Nhập tin nhắn.....',
                  hintStyle:
                      const TextStyle(color: AppColors.textHint),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.s),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),

          // Right button: confirm (edit) or send
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isEditing ? AppColors.success : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEditing ? Icons.check : Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
