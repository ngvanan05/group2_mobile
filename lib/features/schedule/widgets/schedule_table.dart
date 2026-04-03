import 'package:flutter/material.dart';
import '../models/schedule_data.dart';

class EmployeeSchedule {
  final String name;
  final String role;
  final List<String?> shifts; // 7 days: Mon–Sun

  const EmployeeSchedule({required this.name, required this.role, required this.shifts});
}

class ScheduleTable extends StatelessWidget {
  final DateTime weekStart;

  const ScheduleTable({super.key, required this.weekStart});

  static const List<EmployeeSchedule> _employees = [
    EmployeeSchedule(name: 'Đại Trung Tuấn',      role: 'Bảo vệ',              shifts: [null, null, null, null, null, null, null]),
    EmployeeSchedule(name: 'Hoàng Hải Yến',        role: 'Lễ tân',              shifts: [null, null, null, null, null, null, null]),
    EmployeeSchedule(name: 'Nguyễn Lê Bảo Hân',   role: 'Lễ tân',              shifts: [null, null, null, null, null, null, null]),
    EmployeeSchedule(name: 'Vũ Nguyễn Đức Trinh', role: 'Lễ tân',              shifts: [null, null, null, null, null, null, null]),
    EmployeeSchedule(name: 'Dương Thị Quỳnh',      role: 'Lễ tân',              shifts: [null, null, null, null, null, null, null]),
    EmployeeSchedule(name: 'Lê Quang Hải',         role: 'Chuyên viên bảo trì', shifts: [null, null, null, null, null, null, null]),
    EmployeeSchedule(name: 'Hoài Lâm',             role: 'Lễ tân',              shifts: [null, null, null, null, null, null, null]),
  ];

  static const List<String> _dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  static const double _nameColWidth = 130.0;
  static const double _dayColWidth  = 56.0;
  static const double _rowHeight    = 58.0;
  static const double _headerHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    // Load saved schedule for this week, fallback to all null
    final saved = ScheduleStore.get(weekStart);

    return _StickyTable(
      nameColWidth: _nameColWidth,
      dayColWidth: _dayColWidth,
      rowHeight: _rowHeight,
      headerHeight: _headerHeight,
      dayLabels: _dayLabels,
      nameHeader: 'NHÂN VIÊN',
      rowCount: _employees.length,
      nameBuilder: (i) => _NameCell(name: _employees[i].name, sub: _employees[i].role),
      cellBuilder: (i, d) {
        final shift = saved != null && i < saved.length && d < saved[i].length
            ? saved[i][d]
            : null;
        return shift == null
            ? const Text('---', style: TextStyle(color: Colors.grey, fontSize: 13))
            : _ShiftBadge(shift: shift);
      },
    );
  }
}

// ── Reusable sticky-column table ─────────────────────────────────────────────

class _StickyTable extends StatefulWidget {
  final double nameColWidth;
  final double dayColWidth;
  final double rowHeight;
  final double headerHeight;
  final List<String> dayLabels;
  final String nameHeader;
  final int rowCount;
  final Widget Function(int rowIndex) nameBuilder;
  final Widget Function(int rowIndex, int dayIndex) cellBuilder;
  final void Function(int rowIndex, int dayIndex)? onCellTap;

  const _StickyTable({
    required this.nameColWidth,
    required this.dayColWidth,
    required this.rowHeight,
    required this.headerHeight,
    required this.dayLabels,
    required this.nameHeader,
    required this.rowCount,
    required this.nameBuilder,
    required this.cellBuilder,
    this.onCellTap,
  });

  @override
  State<_StickyTable> createState() => _StickyTableState();
}

class _StickyTableState extends State<_StickyTable> {
  final ScrollController _hScroll = ScrollController();

  @override
  void dispose() {
    _hScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalDayWidth = widget.dayColWidth * widget.dayLabels.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Fixed left column ──────────────────────────────────────────────
        SizedBox(
          width: widget.nameColWidth,
          child: Column(
            children: [
              // header
              Container(
                height: widget.headerHeight,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: Text(widget.nameHeader,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
              // rows
              ...List.generate(widget.rowCount, (i) => Container(
                height: widget.rowHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: widget.nameBuilder(i),
              )),
            ],
          ),
        ),
        // ── Scrollable day columns ─────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            controller: _hScroll,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalDayWidth,
              child: Column(
                children: [
                  // header
                  SizedBox(
                    height: widget.headerHeight,
                    child: Row(
                      children: widget.dayLabels.map((d) => _dayHeader(d)).toList(),
                    ),
                  ),
                  // rows
                  ...List.generate(widget.rowCount, (i) => SizedBox(
                    height: widget.rowHeight,
                    child: Row(
                      children: List.generate(widget.dayLabels.length, (d) {
                        return GestureDetector(
                          onTap: widget.onCellTap != null ? () => widget.onCellTap!(i, d) : null,
                          child: Container(
                            width: widget.dayColWidth,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFEEEEEE)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: widget.cellBuilder(i, d),
                          ),
                        );
                      }),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dayHeader(String label) {
    return Container(
      width: widget.dayColWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      alignment: Alignment.center,
      child: Text(label,
          style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
    );
  }
}

// ── Small reusable widgets ────────────────────────────────────────────────────

class _NameCell extends StatelessWidget {
  final String name;
  final String sub;

  const _NameCell({required this.name, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            overflow: TextOverflow.ellipsis),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _ShiftBadge extends StatelessWidget {
  final String shift;

  const _ShiftBadge({required this.shift});

  static const Map<String, Color> _colors = {
    'M5':   Color(0xFFC084FC),
    'A1':   Color(0xFF93C5FD),
    'E9':   Color(0xFFFDBA74),
    'M6SS': Color(0xFFFCD34D),
    'DO':   Color(0xFFFCA5A5),
  };

  static const Map<String, Color> _textColors = {
    'M5':   Color(0xFF6B21A8),
    'A1':   Color(0xFF1D4ED8),
    'E9':   Color(0xFFC2410C),
    'M6SS': Color(0xFF92400E),
    'DO':   Color(0xFFB91C1C),
  };

  @override
  Widget build(BuildContext context) {
    final bg = _colors[shift] ?? Colors.grey;
    final fg = _textColors[shift] ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(shift,
          style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
