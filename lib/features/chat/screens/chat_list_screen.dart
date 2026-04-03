import 'package:flutter/material.dart';
import '../models/conversation_model.dart';
import 'chat_detail_screen.dart';
import '../widgets/new_message_sheet.dart';
import '../screens/chat_search_screen.dart';
import '../../../core/constants/app_constants.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<_ActiveUser> _activeUsers = const [
    _ActiveUser('Linh Chi', true, AppAvatars.linhChi),
    _ActiveUser('Anh Tuấn', true, AppAvatars.anhTuan),
    _ActiveUser('Hoàng Yến', true, AppAvatars.hoangYen),
    _ActiveUser('Sơn Tùng', true, AppAvatars.sonTung),
    _ActiveUser('Bảo Ngọc', true, AppAvatars.baoNgoc),
  ];

  final List<ConversationModel> _conversations = const [
    ConversationModel(
      id: '1',
      name: 'Mai Phương- Lễ tân',
      avatarUrl: AppAvatars.maiPhuong,
      lastMessage: 'Khách phòng 402 cần thêm khăn tắm ạ.',
      time: '10:45',
      isOnline: true,
      hasUnread: true,
    ),
    ConversationModel(
      id: '2',
      name: 'Anh Tuấn - Quản lý sảnh',
      avatarUrl: AppAvatars.anhTuan,
      lastMessage: 'Báo cáo ca trực sáng đã được gửi vào email.',
      time: '09:12',
      isOnline: false,
      hasUnread: false,
    ),
    ConversationModel(
      id: '3',
      name: 'Hoàng Yến - CSKH',
      avatarUrl: AppAvatars.hoangYen,
      lastMessage: 'Yêu cầu hoàn tiền đã xử lý xong.',
      time: 'Hôm qua',
      isOnline: true,
      hasUnread: true,
    ),
    ConversationModel(
      id: '4',
      name: 'Nhóm Buồng Phòng',
      lastMessage: 'Sơn Tùng: Tầng 5 đã dọn xong 12/15 phòng.',
      time: 'Hôm qua',
      isOnline: false,
      hasUnread: false,
      isGroup: true,
    ),
    ConversationModel(
      id: '5',
      name: 'Bảo Ngọc - Kế toán',
      avatarUrl: AppAvatars.baoNgoc,
      lastMessage: 'Dạ vâng, em sẽ kiểm tra lại bảng lương.',
      time: '2 ngày trước',
      isOnline: false,
      hasUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActiveSection(),
                    _buildRecentSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.m, AppSpacing.m, AppSpacing.m, AppSpacing.s),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF192580),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'FP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          const Text(
            'FourPoint Hotel',
            style: TextStyle(
              fontSize: AppTextSize.title,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.textPrimary, size: 26),
            onPressed: () => _showNewMessage(context),
          ),
          IconButton(
            icon: const Icon(Icons.search,
                color: AppColors.textPrimary, size: 26),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ChatSearchScreen()),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ───────────────────────────────────────────────────────────────
  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatSearchScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m, vertical: AppSpacing.s),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m, vertical: AppSpacing.s + 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: AppColors.textHint, size: 20),
            SizedBox(width: AppSpacing.s),
            Text(
              'Tìm kiếm liên hệ hoặc tin nhắn...',
              style: TextStyle(
                  color: AppColors.textHint, fontSize: AppTextSize.body),
            ),
          ],
        ),
      ),
    );
  }

  // ── Active users ─────────────────────────────────────────────────────────────
  Widget _buildActiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.m, AppSpacing.m, AppSpacing.m, AppSpacing.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ĐANG HOẠT ĐỘNG',
                style: TextStyle(
                  fontSize: AppTextSize.small,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                      color: AppColors.error,
                      fontSize: AppTextSize.caption,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            itemCount: _activeUsers.length,
            itemBuilder: (_, i) => _buildActiveAvatar(_activeUsers[i], i == 0),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveAvatar(_ActiveUser user, bool isFirst) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.m),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isFirst
                      ? Border.all(color: AppColors.error, width: 2.5)
                      : null,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(user.avatarUrl),
                  backgroundColor: AppColors.border,
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            user.name.split(' ').last,
            style: const TextStyle(
              fontSize: AppTextSize.small,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent conversations ─────────────────────────────────────────────────────
  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
              AppSpacing.m, AppSpacing.m, AppSpacing.m, AppSpacing.s),
          child: Text(
            'TRÒ CHUYỆN GẦN ĐÂY',
            style: TextStyle(
              fontSize: AppTextSize.small,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _conversations.length,
          itemBuilder: (_, i) => _buildConversationTile(_conversations[i]),
        ),
      ],
    );
  }

  Widget _buildConversationTile(ConversationModel conv) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            userName: conv.name,
            isOnline: conv.isOnline,
            userAvatar: conv.avatarUrl,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m, vertical: AppSpacing.s + 2),
        color: Colors.transparent,
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: conv.avatarUrl != null
                      ? NetworkImage(conv.avatarUrl!)
                      : null,
                  backgroundColor: conv.isGroup
                      ? const Color(0xFFE8EAF6)
                      : AppColors.primaryLight,
                  child: conv.avatarUrl == null
                      ? (conv.isGroup
                          ? const Icon(Icons.group,
                              color: AppColors.primary, size: 24)
                          : Text(
                              conv.name[0],
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ))
                      : null,
                ),
                if (conv.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.m),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv.name,
                          style: TextStyle(
                            fontSize: AppTextSize.body,
                            fontWeight: conv.hasUnread
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        conv.time,
                        style: TextStyle(
                          fontSize: AppTextSize.small,
                          color: conv.hasUnread
                              ? AppColors.error
                              : AppColors.textSecondary,
                          fontWeight: conv.hasUnread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppTextSize.caption,
                            color: conv.hasUnread
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: conv.hasUnread
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (conv.hasUnread)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(left: AppSpacing.s),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.error,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewMessage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewMessageSheet(
        onContactSelected: (name) {
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
}

class _ActiveUser {
  final String name;
  final bool isOnline;
  final String avatarUrl;
  const _ActiveUser(this.name, this.isOnline, this.avatarUrl);
}
