import 'package:flutter/material.dart';
import 'user_management.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Màu sắc chủ đạo đồng bộ với FOURpoint
  final Color primaryColor = const Color(0xFF192580);
  final Color backgroundColor = const Color(0xFFF6F6F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cài đặt",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildSectionTitle("TÀI KHOẢN"),
                _buildSettingItem(
                  icon: Icons.person_outline,
                  title: "Thông tin cá nhân",
                  onTap: () {},
                ),
                _buildSettingItem(
                  icon: Icons.history,
                  title: "Đổi mật khẩu",
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("QUẢN LÝ"),
                _buildSettingItem(
                  icon: Icons.badge_outlined,
                  title: "Quản lý người dùng",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DirectoryScreen()),
                    );
                  },
                ),
                _buildSettingItem(
                  icon: Icons.verified_user_outlined,
                  title: "Quản lý công việc",
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                _buildLogoutItem(onTap: () {}),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Header chứa Avatar và Tên
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=7"),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Đoàn Xuân Toàn",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Quản lý bộ phận",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tiêu đề các nhóm cài đặt (TÀI KHOẢN, QUẢN LÝ)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  // Widget cho từng dòng cài đặt
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: primaryColor, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.blueGrey, size: 20),
      shape: Border(bottom: BorderSide(color: Colors.grey.shade100)),
    );
  }

  // Widget riêng cho nút Đăng xuất
  Widget _buildLogoutItem({required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: const Icon(Icons.logout, color: Colors.red, size: 24),
      title: const Text(
        "Đăng xuất",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  // Thanh điều hướng BottomNav đồng bộ với DirectoryScreen
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 3, // Tab "Tài khoản" đang được chọn
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.blueGrey[300],
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Trang chủ"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Tin nhắn"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Lịch làm"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
      ],
    );
  }
}