import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message_model.dart';
import '../../../core/constants/app_constants.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final String? avatarUrl;
  final void Function(MessageModel msg)? onDelete;
  final void Function(MessageModel msg)? onRecall;
  final void Function(MessageModel msg)? onEdit;
  final void Function()? onCopied; // callback to show toast in parent

  const ChatBubble({
    super.key,
    required this.message,
    this.avatarUrl,
    this.onDelete,
    this.onRecall,
    this.onEdit,
    this.onCopied,
  });

  String _formatTime(DateTime time) {
    final period = time.hour < 12 ? 'AM' : 'PM';
    final hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
            ? 12
            : time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$m $period';
  }

  void _showContextMenu(BuildContext context) {
    final canAct =
        message.isMine && message.status == MessageStatus.normal;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ContextMenu(
        message: message,
        onCopy: () {
          Clipboard.setData(ClipboardData(text: message.content));
          Navigator.pop(context);
          onCopied?.call();
        },
        onEdit: canAct
            ? () {
                Navigator.pop(context);
                onEdit?.call(message);
              }
            : null,
        onDelete: canAct
            ? () {
                Navigator.pop(context);
                onDelete?.call(message);
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (message.status == MessageStatus.recalled) {
      return _buildRecalledBubble();
    }

    final width = MediaQuery.of(context).size.width;

    if (message.isMine) {
      return GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.m,
            bottom: AppSpacing.m,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: width * 0.65),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF7B6CF6), // purple-blue per UI
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  message.content,
                  style: const TextStyle(
                      color: Colors.white, fontSize: AppTextSize.body),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isEdited)
                    const Text(
                      '(Đã chỉnh sửa) ',
                      style: TextStyle(
                          fontSize: AppTextSize.small,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic),
                    ),
                  Text(
                    'Đã xem ${_formatTime(message.time)}',
                    style: const TextStyle(
                      fontSize: AppTextSize.small,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Other person's message
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.m,
          right: AppSpacing.xl,
          bottom: AppSpacing.m,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              backgroundColor: AppColors.border,
              child: avatarUrl == null
                  ? const Icon(Icons.person,
                      size: 18, color: AppColors.textSecondary)
                  : null,
            ),
            const SizedBox(width: AppSpacing.s),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.type == MessageType.image)
                  _buildImageBubble(width)
                else
                  _buildOtherTextBubble(width),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.time),
                  style: const TextStyle(
                    fontSize: AppTextSize.small,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecalledBubble() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.m,
        bottom: AppSpacing.m,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.delete_outline,
                  size: 16, color: AppColors.textSecondary),
              SizedBox(width: 6),
              Text(
                'Tin nhắn đã bị xóa',
                style: TextStyle(
                  fontSize: AppTextSize.caption,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherTextBubble(double width) {
    return Container(
      constraints: BoxConstraints(maxWidth: width * 0.65),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 1)),
        ],
      ),
      child: Text(
        message.content,
        style: const TextStyle(
            color: AppColors.textPrimary, fontSize: AppTextSize.body),
      ),
    );
  }

  Widget _buildImageBubble(double width) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(18),
        bottomLeft: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
      child: Image.network(
        message.content,
        width: width * 0.55,
        height: 160,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width * 0.55,
          height: 160,
          color: AppColors.border,
          child: const Icon(Icons.broken_image,
              color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

// ── Context Menu ───────────────────────────────────────────────────────────────
class _ContextMenu extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onCopy;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ContextMenu({
    required this.message,
    required this.onCopy,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              icon: Icons.copy_outlined,
              label: 'Sao chép',
              color: AppColors.textPrimary,
              onTap: onCopy,
            ),
            if (onEdit != null) ...[
              const Divider(height: 1, color: AppColors.divider),
              _menuItem(
                icon: Icons.edit_outlined,
                label: 'Chỉnh sửa',
                color: AppColors.textPrimary,
                onTap: onEdit!,
              ),
            ],
            if (onDelete != null) ...[
              const Divider(height: 1, color: AppColors.divider),
              _menuItem(
                icon: Icons.delete_outline,
                label: 'Xóa tin nhắn',
                color: AppColors.error,
                onTap: onDelete!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: AppSpacing.m),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTextSize.body,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
