import 'package:flutter/material.dart';
import '../models/schedule_data.dart';

const shiftBgColors = {
  'M5':   Color(0xFFC084FC),
  'A1':   Color(0xFF93C5FD),
  'E9':   Color(0xFFFDBA74),
  'M6SS': Color(0xFFFCD34D),
  'DO':   Color(0xFFFCA5A5),
};

const shiftTextColors = {
  'M5':   Color(0xFF6B21A8),
  'A1':   Color(0xFF1D4ED8),
  'E9':   Color(0xFFC2410C),
  'M6SS': Color(0xFF92400E),
  'DO':   Color(0xFFB91C1C),
};

class ShiftSummary extends StatelessWidget {
  final DateTime weekStart;
  const ShiftSummary({super.key, required this.weekStart});

  Map<String, int> get _counts {
    final result = {for (final k in shiftBgColors.keys) k: 0};
    final saved = ScheduleStore.get(weekStart);
    if (saved == null) return result;
    for (final row in saved) {
      for (final shift in row) {
        if (shift != null && result.containsKey(shift)) {
          result[shift] = result[shift]! + 1;
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final counts = _counts;
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
          const Text('TỔNG SỐ CA LÀM VIỆC',
              style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: shiftBgColors.entries.map((e) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: e.value, borderRadius: BorderRadius.circular(8)),
                    child: Text(e.key,
                        style: TextStyle(
                          color: shiftTextColors[e.key],
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(width: 4),
                  Text('${counts[e.key] ?? 0}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
