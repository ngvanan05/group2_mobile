import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class _Contact {
  final String name;
  final String role;
  final String avatarUrl;
  const _Contact(this.name, this.role, this.avatarUrl);
}

final _contacts = [
  _Contact('Văn Hùng', 'Quản lý Front Desk', AppAvatars.vanHung),
  _Contact('Thị Mai', 'Trưởng bộ phận Housekeeping', AppAvatars.thiMai),
  _Contact('Minh Tuấn', 'Bảo trì kỹ thuật', AppAvatars.minhTuan),
  _Contact('Nguyễn Hà', 'Nhân viên Lễ tân', AppAvatars.nguyenHa),
  _Contact('Võ Thành Tùng', 'Giám sát An ninh', AppAvatars.voThanhTung),
];

class NewMessageSheet extends StatefulWidget {
  final void Function(String name) onContactSelected;

  const NewMessageSheet({super.key, required this.onContactSelected});

  @override
  State<NewMessageSheet> createState() => _NewMessageSheetState();
}

class _NewMessageSheetState extends State<NewMessageSheet> {
  String _query = '';

  List<_Contact> get _filtered => _contacts
      .where((c) =>
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.role.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.s),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.m, AppSpacing.m, AppSpacing.s, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tin nhắn mới',
                    style: TextStyle(
                      fontSize: AppTextSize.subtitle,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Text(
              'Bắt đầu trò chuyện với nhân viên hoặc tạo nhóm',
              style: TextStyle(
                  fontSize: AppTextSize.caption,
                  color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          // Search
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Tìm theo tên hoặc bộ phận...',
                  hintStyle: TextStyle(color: AppColors.textHint),
                  prefixIcon:
                      Icon(Icons.search, color: AppColors.textHint),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: AppSpacing.s),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          // Create group button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.group_add_outlined,
                  color: AppColors.primary),
              label: const Text(
                'Tạo nhóm trò chuyện mới',
                style: TextStyle(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(
                    color: AppColors.primary.withOpacity(0.5),
                    style: BorderStyle.solid),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'GỢI Ý & GẦN ĐÂY',
                style: TextStyle(
                  fontSize: AppTextSize.small,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          // Contact list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final c = _filtered[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(c.avatarUrl),
                  backgroundColor: AppColors.border,
                ),
                title: Text(c.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppTextSize.body)),
                subtitle: Text(c.role,
                    style: const TextStyle(
                        fontSize: AppTextSize.caption,
                        color: AppColors.textSecondary)),
                onTap: () {
                  Navigator.pop(context);
                  widget.onContactSelected(c.name);
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }
}
