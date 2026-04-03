import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import 'chat_detail_screen.dart';

class _SearchResult {
  final String name;
  final String preview;
  final String time;
  final bool isFile;
  final String? avatarUrl;
  const _SearchResult(this.name, this.preview, this.time,
      {this.isFile = false, this.avatarUrl});
}

const _allResults = [
  _SearchResult('Lê Minh Tuấn',
      'Chào anh, em đã gửi báo cáo doanh thu tháng 10 qua email rồi ạ. Anh xem qua nhé.',
      'Hôm qua', avatarUrl: AppAvatars.leMinhTuan),
  _SearchResult('Nguyễn Thùy Linh',
      'Cần hoàn thành gấp báo cáo nhân sự cho cuộc họp sáng thứ Hai tới. Mọi người lưu ý.',
      '2 ngày trước', avatarUrl: AppAvatars.nguyenThuyLinh),
  _SearchResult('Trần Văn Nam',
      'Dữ liệu trong báo cáo kho có chút sai lệch ở khu vực A. Để em kiểm tra lại.',
      '15:30', avatarUrl: AppAvatars.tranVanNam),
  _SearchResult('Báo cáo Q3_Final.pdf',
      '2.4 MB • Được gửi bởi Hoàng An', '1 tuần trước',
      isFile: true),
  _SearchResult('Phạm Minh Hạnh',
      'Chị đã phê duyệt mẫu báo cáo mới. Em có thể áp dụng cho các phòng ban khác.',
      '20 thg 10', avatarUrl: AppAvatars.phamMinhHanh),
  _SearchResult('Anh Tuấn - Quản lý sảnh',
      'Báo cáo ca trực sáng đã được gửi vào email. Anh xem và phản hồi nhé.',
      '09:12', avatarUrl: AppAvatars.anhTuan),
  _SearchResult('Mai Phương - Lễ tân',
      'Khách phòng 402 cần thêm khăn tắm ạ. Anh có thể xử lý không?',
      '10:45', avatarUrl: AppAvatars.maiPhuong),
  _SearchResult('Hoàng Yến - CSKH',
      'Yêu cầu hoàn tiền đã xử lý xong. Khách hàng đã xác nhận.',
      'Hôm qua', avatarUrl: AppAvatars.hoangYen),
  _SearchResult('Bảo Ngọc - Kế toán',
      'Dạ vâng, em sẽ kiểm tra lại bảng lương và gửi anh trước 5 giờ.',
      '2 ngày trước', avatarUrl: AppAvatars.baoNgoc),
];

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  int _filterIndex = 0; // 0=Tất cả, 1=Tin nhắn, 2=Tệp, 3=Liên hệ

  final _filters = ['Tất cả', 'Tin nhắn', 'Tệp', 'Liên hệ'];

  List<_SearchResult> get _results {
    if (_query.isEmpty) return [];
    return _allResults.where((r) {
      if (_filterIndex == 2) return r.isFile;
      if (_filterIndex == 1) return !r.isFile;
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tìm kiếm tin nhắn',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppTextSize.subtitle,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textHint),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm...',
                        hintStyle: TextStyle(color: AppColors.textHint),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: AppSpacing.s + 2),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                      child: const Icon(Icons.close,
                          color: AppColors.textSecondary, size: 20),
                    ),
                ],
              ),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              itemCount: _filters.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s),
                child: GestureDetector(
                  onTap: () => setState(() => _filterIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m, vertical: 6),
                    decoration: BoxDecoration(
                      color: _filterIndex == i
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _filterIndex == i
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        color: _filterIndex == i
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: AppTextSize.caption,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          // Results
          if (_query.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'KẾT QUẢ TÌM KIẾM (${_results.length})',
                  style: const TextStyle(
                    fontSize: AppTextSize.small,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, i) => _buildResultTile(_results[i]),
              ),
            ),
          ] else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildResultTile(_SearchResult result) {
    return InkWell(
      onTap: () {
        if (!result.isFile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ChatDetailScreen(userName: result.name, isOnline: false),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m, vertical: AppSpacing.s + 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: result.avatarUrl != null
                  ? NetworkImage(result.avatarUrl!)
                  : null,
              backgroundColor: result.isFile
                  ? const Color(0xFFFFECE0)
                  : AppColors.primaryLight,
              child: result.avatarUrl == null
                  ? (result.isFile
                      ? const Icon(Icons.insert_drive_file,
                          color: Color(0xFFFF6B35), size: 22)
                      : Text(
                          result.name[0],
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  : null,
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppTextSize.body,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        result.time,
                        style: const TextStyle(
                          fontSize: AppTextSize.small,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  _buildHighlightedText(result.preview, _query),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String keyword) {
    if (keyword.isEmpty) {
      return Text(text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: AppTextSize.caption,
              color: AppColors.textSecondary));
    }
    final lower = text.toLowerCase();
    final kLower = keyword.toLowerCase();
    final idx = lower.indexOf(kLower);
    if (idx == -1) {
      return Text(text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: AppTextSize.caption,
              color: AppColors.textSecondary));
    }
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
            fontSize: AppTextSize.caption, color: AppColors.textSecondary),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + keyword.length),
            style: const TextStyle(
              backgroundColor: Color(0xFFFFEB3B),
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: text.substring(idx + keyword.length)),
        ],
      ),
    );
  }
}
