import 'package:flutter/material.dart';

class _LegendItem {
  final String code;
  final Color bgColor;
  final Color textColor;
  final String title;
  final String subtitle;
  const _LegendItem({required this.code, required this.bgColor, required this.textColor, required this.title, required this.subtitle});
}

class ShiftLegend extends StatelessWidget {
  const ShiftLegend({super.key});

  static const List<_LegendItem> _items = [
    _LegendItem(code: 'M5',   bgColor: Color(0xFFC084FC), textColor: Color(0xFF6B21A8), title: 'Ca Sáng: 5h – 13h',  subtitle: 'Morning Shift'),
    _LegendItem(code: 'A1',   bgColor: Color(0xFF93C5FD), textColor: Color(0xFF1D4ED8), title: 'Ca Chiều: 13h – 21h', subtitle: 'Afternoon Shift'),
    _LegendItem(code: 'E9',   bgColor: Color(0xFFFDBA74), textColor: Color(0xFFC2410C), title: 'Ca Tối: 21h – 5h',    subtitle: 'Evening Shift'),
    _LegendItem(code: 'M6SS', bgColor: Color(0xFFFCD34D), textColor: Color(0xFF92400E), title: 'Ca Đặc Biệt',         subtitle: 'Mid Shift'),
    _LegendItem(code: 'DO',   bgColor: Color(0xFFFCA5A5), textColor: Color(0xFFB91C1C), title: 'Nghỉ',                subtitle: 'Day Off'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CHÚ THÍCH CA LÀM VIỆC',
              style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          for (int i = 0; i < _items.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(child: _buildItem(_items[i])),
                  if (i + 1 < _items.length) Expanded(child: _buildItem(_items[i + 1])),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItem(_LegendItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(color: item.bgColor, borderRadius: BorderRadius.circular(8)),
          child: Text(item.code,
              style: TextStyle(color: item.textColor, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              Text(item.subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
