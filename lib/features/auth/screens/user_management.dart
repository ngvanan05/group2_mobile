import 'package:flutter/material.dart';
import 'user_detail.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final Color primaryColor = const Color(0xFF192580);
  final Color backgroundColor = const Color(0xFFF6F6F8);
  final Color cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: primaryColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildEmployeeCard("Alex Rivera", "Senior Software Engineer", true, "1"),
                  _buildEmployeeCard("Sarah Jenkins", "Director of Marketing", true, "2"),
                  _buildEmployeeCard("Marcus Thorne", "Backend Architect", false, "3"),
                  _buildEmployeeCard("Elena Rodriguez", "Head of Product", true, "4"),
                  _buildEmployeeCard("Jordan Smith", "QA Engineer", false, "5"),
                  _buildEmployeeCard("Chloe Kim", "UI Designer", true, "6"),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo đồng bộ với font chữ và màu sắc của UserDetailScreen
              Text(
                "FOURpoint",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0,
                ),
              ),
              Row(
                children: [
                  // Thay icon notification bằng màu primary nhẹ để đồng bộ
                  Icon(Icons.notifications_none, color: primaryColor.withOpacity(0.6)),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=me"),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: "Search employees, roles, or skills...",
              prefixIcon: Icon(Icons.search, color: primaryColor.withOpacity(0.4)),
              filled: true,
              fillColor: Colors.blueGrey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip("All", true),
                _filterChip("Engineering", false),
                _filterChip("Marketing", false),
                _filterChip("Offline", false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.blueGrey[600],
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(String name, String role, bool isOnline, String id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserDetailScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueGrey[50]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueGrey[100],
                backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$id"),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[400],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: primaryColor.withOpacity(0.3), size: 20),
        ],
      ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.blueGrey[300],
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "HOME"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "DIRECTORY"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "CHAT"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "PROFILE"),
      ],
    );
  }
}