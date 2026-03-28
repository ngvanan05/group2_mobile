import 'package:flutter/material.dart';

class AudiencePicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const AudiencePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> _options = [
    {
      'label': 'Toàn khách sạn',
      'icon': Icons.public,
      'color': Color(0xFF1976D2),
    },
    {
      'label': 'Nhóm',
      'icon': Icons.group,
      'color': Color(0xFF43A047),
    },
    {
      'label': 'Chỉ mình tôi',
      'icon': Icons.lock,
      'color': Color(0xFF757575),
    },
  ];

  void _show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Chọn đối tượng xem',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ..._options.map((opt) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        (opt['color'] as Color).withOpacity(0.15),
                    child: Icon(opt['icon'] as IconData,
                        color: opt['color'] as Color, size: 20),
                  ),
                  title: Text(opt['label'] as String),
                  trailing: selected == opt['label']
                      ? const Icon(Icons.check, color: Color(0xFF1976D2))
                      : null,
                  onTap: () {
                    onChanged(opt['label'] as String);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opt = _options.firstWhere(
      (o) => o['label'] == selected,
      orElse: () => _options.first,
    );
    return GestureDetector(
      onTap: () => _show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: (opt['color'] as Color).withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(opt['icon'] as IconData,
                size: 14, color: opt['color'] as Color),
            const SizedBox(width: 4),
            Text(
              selected,
              style: TextStyle(
                  fontSize: 13,
                  color: opt['color'] as Color,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down,
                size: 16, color: opt['color'] as Color),
          ],
        ),
      ),
    );
  }
}
