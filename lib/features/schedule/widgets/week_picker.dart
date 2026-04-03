import 'package:flutter/material.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

DateTime weekMonday(DateTime date) =>
    DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));

int _isoWeek(DateTime date) {
  final thu = date.add(Duration(days: 4 - date.weekday));
  final firstThu = DateTime(thu.year, 1, 1);
  return 1 + ((thu.difference(firstThu).inDays) / 7).floor();
}

const _monthNames = [
  '', 'Tháng Một', 'Tháng Hai', 'Tháng Ba', 'Tháng Tư',
  'Tháng Năm', 'Tháng Sáu', 'Tháng Bảy', 'Tháng Tám',
  'Tháng Chín', 'Tháng Mười', 'Tháng Mười Một', 'Tháng Mười Hai',
];

// ── Public helper ─────────────────────────────────────────────────────────────

Future<DateTime?> showWeekPicker({
  required BuildContext context,
  required DateTime initialWeek,
}) =>
    showDialog<DateTime>(
      context: context,
      builder: (_) => _WeekPickerDialog(initialWeek: initialWeek),
    );

// ── Dialog ────────────────────────────────────────────────────────────────────

class _WeekPickerDialog extends StatefulWidget {
  final DateTime initialWeek;
  const _WeekPickerDialog({required this.initialWeek});

  @override
  State<_WeekPickerDialog> createState() => _WeekPickerDialogState();
}

class _WeekPickerDialogState extends State<_WeekPickerDialog> {
  late DateTime _selected; // always a Monday
  late DateTime _month;    // first day of displayed month

  @override
  void initState() {
    super.initState();
    _selected = weekMonday(widget.initialWeek);
    _month = DateTime(_selected.year, _selected.month, 1);
  }

  void _prevMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month - 1, 1));

  void _nextMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month + 1, 1));

  void _today() {
    final mon = weekMonday(DateTime.now());
    setState(() {
      _selected = mon;
      _month = DateTime(mon.year, mon.month, 1);
    });
  }

  List<DateTime> _weeks() {
    var mon = weekMonday(_month);
    final result = <DateTime>[];
    for (var i = 0; i < 6; i++) {
      final sun = mon.add(const Duration(days: 6));
      // include row if it overlaps the displayed month
      if (mon.year > _month.year ||
          (mon.year == _month.year && mon.month > _month.month)) break;
      result.add(mon);
      mon = mon.add(const Duration(days: 7));
      if (sun.month != _month.month && mon.month != _month.month) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    const sel = Color(0xFF1565C0);
    final weeks = _weeks();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month header
            Row(
              children: [
                Text('${_monthNames[_month.month]} ${_month.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.arrow_drop_down, size: 20),
                const Spacer(),
                IconButton(
                    onPressed: _prevMonth,
                    icon: const Icon(Icons.arrow_upward, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints()),
                const SizedBox(width: 12),
                IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.arrow_downward, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints()),
              ],
            ),
            const SizedBox(height: 10),
            // Day labels
            Row(children: [
              _hdr('Tuần'),
              for (final d in ['H', 'B', 'T', 'N', 'S', 'B', 'C']) _hdr(d),
            ]),
            const SizedBox(height: 4),
            // Week rows
            ...weeks.map((mon) {
              final isSel = mon == _selected;
              return GestureDetector(
                onTap: () {
                  setState(() => _selected = mon);
                  Navigator.pop(context, mon);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: isSel
                      ? BoxDecoration(
                          color: sel,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: sel, width: 2),
                        )
                      : null,
                  child: Row(
                    children: [
                      _cell('${_isoWeek(mon)}', isSel, true),
                      ...List.generate(7, (i) {
                        final d = mon.add(Duration(days: i));
                        final inMonth = d.month == _month.month;
                        return _cell('${d.day}', isSel, inMonth);
                      }),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _today,
              child: const Text('Tuần này',
                  style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hdr(String t) => SizedBox(
        width: 34,
        child: Center(
          child: Text(t,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      );

  Widget _cell(String t, bool selected, bool inMonth) => SizedBox(
        width: 34,
        height: 34,
        child: Center(
          child: Text(t,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? Colors.white
                    : inMonth
                        ? Colors.black87
                        : Colors.black26,
              )),
        ),
      );
}

// ── Read-only week view dialog ────────────────────────────────────────────────

Future<void> showWeekViewDialog({
  required BuildContext context,
  required DateTime currentWeek,
}) =>
    showDialog<void>(
      context: context,
      builder: (_) => _WeekViewDialog(currentWeek: currentWeek),
    );

class _WeekViewDialog extends StatefulWidget {
  final DateTime currentWeek;
  const _WeekViewDialog({required this.currentWeek});

  @override
  State<_WeekViewDialog> createState() => _WeekViewDialogState();
}

class _WeekViewDialogState extends State<_WeekViewDialog> {
  late DateTime _month;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = weekMonday(widget.currentWeek);
    _month = DateTime(_selected.year, _selected.month, 1);
  }

  void _prevMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month - 1, 1));

  void _nextMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month + 1, 1));

  List<DateTime> _weeks() {
    var mon = weekMonday(_month);
    final result = <DateTime>[];
    for (var i = 0; i < 6; i++) {
      final sun = mon.add(const Duration(days: 6));
      if (mon.year > _month.year ||
          (mon.year == _month.year && mon.month > _month.month)) break;
      result.add(mon);
      mon = mon.add(const Duration(days: 7));
      if (sun.month != _month.month && mon.month != _month.month) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    const sel = Color(0xFF1565C0);
    final weeks = _weeks();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month header
            Row(
              children: [
                Text('${_monthNames[_month.month]} ${_month.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.arrow_drop_down, size: 20),
                const Spacer(),
                IconButton(
                    onPressed: _prevMonth,
                    icon: const Icon(Icons.arrow_upward, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints()),
                const SizedBox(width: 12),
                IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.arrow_downward, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints()),
              ],
            ),
            const SizedBox(height: 10),
            // Day labels
            Row(children: [
              _hdr('Tuần'),
              for (final d in ['H', 'B', 'T', 'N', 'S', 'B', 'C']) _hdr(d),
            ]),
            const SizedBox(height: 4),
            // Week rows (read-only, no onTap)
            ...weeks.map((mon) {
              final isSel = mon == _selected;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: isSel
                    ? BoxDecoration(
                        color: sel,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: sel, width: 2),
                      )
                    : null,
                child: Row(
                  children: [
                    _cell('${_isoWeek(mon)}', isSel, true),
                    ...List.generate(7, (i) {
                      final d = mon.add(Duration(days: i));
                      final inMonth = d.month == _month.month;
                      return _cell('${d.day}', isSel, inMonth);
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 14),
            // Close button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text('Đóng',
                  style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hdr(String t) => SizedBox(
        width: 34,
        child: Center(
          child: Text(t,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      );

  Widget _cell(String t, bool selected, bool inMonth) => SizedBox(
        width: 34,
        height: 34,
        child: Center(
          child: Text(t,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? Colors.white
                    : inMonth
                        ? Colors.black87
                        : Colors.black26,
              )),
        ),
      );
}

