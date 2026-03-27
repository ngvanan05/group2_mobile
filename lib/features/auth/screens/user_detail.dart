import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  // Màu xanh đậm đặc trưng của FOURpoint
  final Color primaryColor = const Color(0xFF192580);
  final Color goldAccent = const Color(0xFFD4AF37);
  final Color staffGreen = const Color(0xFF2E7D32);
  final Color backgroundColor = const Color(0xFFF6F6F8);

  bool isAdmin = true;
  bool isManager = true;
  bool isStaff = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Personal Info"),
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle("Organization"),
                      _buildOrgCard(),
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle("User Roles"),
                      _buildRolesCard(),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildStickyBottomAction(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        // Giữ lại nút back để điều hướng, đổi màu theo primary
        icon: Icon(Icons.arrow_back, color: primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "FOURpoint User Details",
        style: TextStyle(
          color: primaryColor, 
          fontWeight: FontWeight.bold, 
          fontSize: 18
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor.withOpacity(0.05), backgroundColor],
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)],
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=7"),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Alex Thompson", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))
          ),
          Text(
            "Senior Solutions Architect", 
            style: TextStyle(fontSize: 14, color: primaryColor.withOpacity(0.7), fontWeight: FontWeight.w600)
          ),
          const SizedBox(height: 16),
          // Nút Change Photo dạng chữ tối giản
          TextButton(
            onPressed: () {},
            child: Text(
              "Change Photo", 
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11, 
          fontWeight: FontWeight.bold, 
          color: primaryColor.withOpacity(0.5), 
          letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildInputField("Full Name", "Alex Thompson"),
          const Divider(height: 1, indent: 16),
          _buildInputField("Email Address", "alex.thompson@fourpoint.com"),
          const Divider(height: 1, indent: 16),
          _buildInputField("Phone Number", "+1 (555) 012-3456"),
        ],
      ),
    );
  }

  Widget _buildOrgCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildListTile("Department", "Engineering & Infrastructure"),
          const Divider(height: 1, indent: 16),
          _buildListTile("Manager", "Sarah Jenkins"),
        ],
      ),
    );
  }

  Widget _buildRolesCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildRoleToggle("Admin", "Full access", goldAccent, isAdmin, (v) => setState(() => isAdmin = v)),
          const Divider(height: 1, indent: 16),
          _buildRoleToggle("Manager", "Team oversight", primaryColor, isManager, (v) => setState(() => isManager = v)),
          const Divider(height: 1, indent: 16),
          _buildRoleToggle("Staff", "Standard access", staffGreen, isStaff, (v) => setState(() => isStaff = v)),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildListTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
          ]),
          Icon(Icons.unfold_more, color: primaryColor.withOpacity(0.3), size: 18),
        ],
      ),
    );
  }

  Widget _buildRoleToggle(String title, String sub, Color activeColor, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: value ? activeColor : Colors.blueGrey)),
              Text(sub, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
            ]),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: activeColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomAction() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(top: BorderSide(color: Colors.blueGrey.withOpacity(0.1))),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text(
            "SAVE CHANGES", 
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1)
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blueGrey.withOpacity(0.1)),
    );
  }
}