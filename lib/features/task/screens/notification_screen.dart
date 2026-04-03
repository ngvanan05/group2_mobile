import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Chưa đọc'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllNotifications(),
          _buildUnreadNotifications(),
        ],
      ),
    );
  }

  Widget _buildAllNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationItem(
          icon: Icons.description,
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.shade50,
          title: 'Bạn có nhiệm vụ mới: Sửa bồn cầu rò rỉ nước tại Phòng 402',
          subtitle: 'Công việc mới được giao bởi Quản lý kỹ thuật',
          time: '5 PHÚT TRƯỚC',
          isUnread: true,
        ),
        const SizedBox(height: 12),
        _buildNotificationItem(
          icon: Icons.access_time,
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.shade50,
          title: 'Nhắc nhở: Ca làm việc của bạn bắt đầu sau 30 phút',
          subtitle: 'Vui lòng có mặt tại quầy lễ tân để bàn giao ca',
          time: '15 PHÚT TRƯỚC',
          isUnread: true,
        ),
        const SizedBox(height: 12),
        _buildNotificationItem(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          iconBgColor: Colors.green.shade50,
          title: 'Quản lý đã phê duyệt hoàn thành công việc tại Phòng 205',
          subtitle: 'Hệ thống đã cập nhật trạng thái phòng',
          time: '1 GIỜ TRƯỚC',
          isUnread: false,
        ),
        const SizedBox(height: 12),
        _buildNotificationItem(
          icon: Icons.info_outline,
          iconColor: Colors.grey,
          iconBgColor: Colors.grey.shade100,
          title: 'Bản tin nội bộ tuần mới đã sẵn sàng',
          subtitle: 'Xem thông tin cập nhật từ bộ phận Nhân sự',
          time: '3 GIỜ TRƯỚC',
          isUnread: false,
        ),
      ],
    );
  }

  Widget _buildUnreadNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationItem(
          icon: Icons.description,
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.shade50,
          title: 'Bạn có nhiệm vụ mới: Sửa bồn cầu rò rỉ nước tại Phòng 402',
          subtitle: 'Công việc mới được giao bởi Quản lý kỹ thuật',
          time: '5 PHÚT TRƯỚC',
          isUnread: true,
        ),
        const SizedBox(height: 12),
        _buildNotificationItem(
          icon: Icons.access_time,
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.shade50,
          title: 'Nhắc nhở: Ca làm việc của bạn bắt đầu sau 30 phút',
          subtitle: 'Vui lòng có mặt tại quầy lễ tân để bàn giao ca',
          time: '15 PHÚT TRƯỚC',
          isUnread: true,
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
