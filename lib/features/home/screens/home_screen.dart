import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../widgets/story_input.dart';
import 'notification_screen.dart';
import '../../../features/post/models/post_model.dart';
import '../../../features/post/screens/create_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<PostData> _posts = [
    const PostData(
      id: '1',
      authorName: 'Nguyen Van Minh',
      authorInitials: 'NM',
      avatarColorValue: 0xFF1565C0,
      badge: 'Toan khach san',
      badgeColorValue: 0xFF1976D2,
      role: 'Le tan',
      timeAgo: '2 gio truoc',
      title: 'Thong bao: Dao tao quy trinh check-in moi',
      content: 'Chao cac ban trong bo phan le tan! Tu ngay mai (05/02), chung ta se ap dung quy trinh check-in moi de toi uu thoi gian phuc vu khach. Buoi dao tao se dien ra vao 14:00 tai phong hop tang 2. Mong moi nguoi sap xep tham gia day du nhe!',
      likes: 24,
      comments: 8,
      shares: 3,
    ),
    const PostData(
      id: '2',
      authorName: 'Nguyen Nhat Ha',
      authorInitials: 'NH',
      avatarColorValue: 0xFF00897B,
      badge: 'Bo phan',
      badgeColorValue: 0xFFFF8F00,
      role: 'Le tan',
      timeAgo: '2 gio truoc',
      title: 'Chuc mung doi ngu xuat sac thang 1!',
      content: 'Xin chuc mung cac ban Nguyen Thi Lan, Pham Van Tu va Le Thi Mai da hoan thanh xuat sac nhiem vu trong thang vua qua. Dac biet, phong 501-520 dat diem danh gia hoan hao tu khach hang. Cam on su tan tam cua cac ban!',
      likes: 45,
      comments: 15,
      shares: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PostData> get _filteredPosts {
    if (_searchQuery.isEmpty) return _posts;
    return _posts.where((post) {
      return post.title.toLowerCase().contains(_searchQuery) ||
          post.content.toLowerCase().contains(_searchQuery) ||
          post.authorName.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _openCreatePost() async {
    final result = await Navigator.push<PostData>(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
    if (result != null) {
      setState(() => _posts.insert(0, result));
      if (mounted) _showToast('Dang bai thanh cong');
    }
  }

  Future<void> _openEditPost(PostData post) async {
    final result = await Navigator.push<PostData>(
      context,
      MaterialPageRoute(builder: (_) => CreatePostScreen(editPost: post)),
    );
    if (result != null) {
      setState(() {
        final idx = _posts.indexWhere((p) => p.id == post.id);
        if (idx != -1) _posts[idx] = result;
      });
      if (mounted) _showToast('Chinh sua thanh cong');
    }
  }

  Future<void> _deletePost(PostData post) async {
    final confirmed = await _showConfirmDialog(
      icon: Icons.delete_outline,
      iconBgColor: const Color(0xFFFFEBEE),
      iconColor: Colors.red,
      title: 'Xac nhan xoa?',
      message: 'Ban co chac chan muon xoa bai viet nay khong? Hanh dong nay khong the hoan tac.',
      confirmLabel: 'Xoa',
      confirmColor: Colors.red,
    );
    if (confirmed) {
      setState(() => _posts.removeWhere((p) => p.id == post.id));
      if (mounted) _showToast('Xoa bai viet thanh cong');
    }
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
                    decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Huy', style: TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(confirmLabel, style: const TextStyle(color: Colors.white)),
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

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 80,
        left: 24,
        right: 24,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
                border: Border.all(color: const Color(0xFFB9F6CA)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF66BB6A),
                    radius: 12,
                    child: Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Text(message, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 10),
                  const Icon(Icons.close, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), entry.remove);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tim kiem bai viet tren FourPoints',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87, size: 24),
            onPressed: () {},
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('FP',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 10),
          const Text('FourPoint Hotel',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black87, size: 26),
          onPressed: () => setState(() => _isSearching = true),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.black87, size: 26),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text('7', style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody() {
    final posts = _filteredPosts;
    return ListView(
      children: [
        if (!_isSearching)
          StoryInput(onTap: _openCreatePost),
        if (posts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 56, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'Khong tim thay ket qua cho "$_searchQuery"',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...posts.map((post) => PostCard(
                post: post,
                onEdit: () => _openEditPost(post),
                onDelete: () => _deletePost(post),
              )),
      ],
    );
  }

}