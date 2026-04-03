import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'week_picker.dart';

class WeekNavigator extends StatelessWidget {
  final DateTime weekStart;
  final bool isCurrentWeek;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const WeekNavigator({
    super.key,
    required this.weekStart,
    required this.isCurrentWeek,
    required this.onPrevious,
    required this.onNext,
  });

  String _formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onPrevious,
            child: const Column(
              children: [
                Icon(Icons.chevron_left, color: Color(0xFF1565C0)),
                Text('Tuần\ntrước', textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF1565C0), fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showWeekViewDialog(
              context: context,
              currentWeek: weekStart,
            ),
            child: Column(
            children: [
              Text(
                '${_formatDate(weekStart)} –\n${_formatDate(weekEnd)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (isCurrentWeek)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('TUẦN HIỆN TẠI',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          ),
          GestureDetector(
            onTap: onNext,
            child: const Column(
              children: [
                Icon(Icons.chevron_right, color: Color(0xFF1565C0)),
                Text('Tuần sau\n›', textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF1565C0), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
