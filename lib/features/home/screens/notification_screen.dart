import 'package:flutter/material.dart';

class NotificationItem {
  final String avatarInitials;
  final Color avatarColor;
  final String message;
  final String timeAgo;
  final bool isRead;
  final IconData actionIcon;
  final Color actionIconColor;

  const NotificationItem({
    required this.avatarInitials,
    required this.avatarColor,
    required this.message,
    required this.timeAgo,
    required this.isRead,
    required this.actionIcon,
    required this.actionIconColor,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> _notifications = const [
    NotificationItem(
      avatarInitials: 'NM',
      avatarColor: Color(0xFF1565C0),
      message: 'Nguyễn Văn Minh đã thích bài viết của bạn.',
      timeAgo: '5 phút trước',
      isRead: false,
      actionIcon: Icons.thumb_up,
      actionIconColor: Color(0xFF1976D2),
    ),
    NotificationItem(
      avatarInitials: 'NH',
      avatarColor: Color(0xFF00897B),
      message: 'Nguyễn Nhật Hạ đã bình luận: "Cảm ơn bạn rất nhiều!"',
      timeAgo: '30 phút trước',
      isRead: false,
      actionIcon: Icons.chat_bubble,
      actionIconColor: Color(0xFF43A047),
    ),
    NotificationItem(
      avatarInitials: 'TL',
      avatarColor: Color(0xFFE53935),
      message: 'Trần Lan đã chia sẻ bài viết của bạn.',
      timeAgo: '1 giờ trước',
      isRead: false,
      actionIcon: Icons.reply,
      actionIconColor: Color(0xFFE53935),
    ),
    NotificationItem(
      avatarInitials: 'PV',
      avatarColor: Color(0xFF8E24AA),
      message: 'Phạm Văn Tú đã thích bình luận của bạn.',
      timeAgo: '2 giờ trước',
      isRead: true,
      actionIcon: Icons.thumb_up,
      actionIconColor: Color(0xFF1976D2),
    ),
    NotificationItem(
      avatarInitials: 'LM',
      avatarColor: Color(0xFFFF8F00),
      message: 'Lê Thị Mai đã nhắc đến bạn trong một bình luận.',
      timeAgo: '3 giờ trước',
      isRead: true,
      actionIcon: Icons.alternate_email,
      actionIconColor: Color(0xFFFF8F00),
    ),
    NotificationItem(
      avatarInitials: 'FP',
      avatarColor: Color(0xFF1565C0),
      message: 'Thông báo hệ thống: Lịch họp tháng 2 đã được cập nhật.',
      timeAgo: '5 giờ trước',
      isRead: true,
      actionIcon: Icons.notifications,
      actionIconColor: Color(0xFF1565C0),
    ),
    NotificationItem(
      avatarInitials: 'NM',
      avatarColor: Color(0xFF1565C0),
      message: 'Nguyễn Văn Minh đã chia sẻ bài viết của bạn.',
      timeAgo: 'Hôm qua',
      isRead: true,
      actionIcon: Icons.reply,
      actionIconColor: Color(0xFFE53935),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () {
                // TODO: đánh dấu tất cả đã đọc
              },
              child: const Text(
                'Đọc tất cả',
                style: TextStyle(color: Color(0xFF1565C0), fontSize: 14),
              ),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return _NotificationTile(item: item);
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.isRead ? Colors.white : const Color(0xFFE8F0FE),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar với icon action nhỏ ở góc
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: item.avatarColor,
                radius: 24,
                child: Text(
                  item.avatarInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: item.actionIconColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Icon(
                    item.actionIcon,
                    color: Colors.white,
                    size: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Nội dung
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        item.isRead ? FontWeight.normal : FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: item.isRead
                        ? Colors.grey[500]
                        : const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
          // Chấm xanh nếu chưa đọc
          if (!item.isRead)
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 4, left: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF1565C0),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
