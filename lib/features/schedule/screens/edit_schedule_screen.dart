import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/schedule_data.dart';
import '../widgets/shift_legend.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/success_toast.dart';

const List<String> _dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
const List<String> _shiftOptions = ['M5', 'A1', 'E9', 'M6SS', 'DO'];

const Map<String, Color> _shiftBg = {
  'M5':   Color(0xFFC084FC),
  'A1':   Color(0xFF93C5FD),
  'E9':   Color(0xFFFDBA74),
  'M6SS': Color(0xFFFCD34D),
  'DO':   Color(0xFFFCA5A5),
};
const Map<String, Color> _shiftFg = {
  'M5':   Color(0xFF6B21A8),
  'A1':   Color(0xFF1D4ED8),
  'E9':   Color(0xFFC2410C),
  'M6SS': Color(0xFF92400E),
  'DO':   Color(0xFFB91C1C),
};

const double _nameColWidth = 130.0;
const double _dayColWidth  = 56.0;
const double _rowHeight    = 60.0;
const double _headerHeight = 36.0;

class _Employee {
  final String name;
  final String role;
  const _Employee(this.name, this.role);
}

const List<_Employee> _employees = [
  _Employee('Đại Trung Tuấn',      'Bảo vệ'),
  _Employee('Hoàng Hải Yến',        'Lễ tân'),
  _Employee('Nguyễn Lê Bảo Hân',   'Lễ tân'),
  _Employee('Vũ Nguyễn Đức Trinh', 'Lễ tân'),
  _Employee('Dương Thị Quỳnh',      'Lễ tân'),
  _Employee('Lê Quang Hải',         'Chuyên viên bảo trì'),
  _Employee('Hoài Lâm',             'Lễ tân'),
];

class EditScheduleScreen extends StatefulWidget {
  final DateTime weekStart;
  const EditScheduleScreen({super.key, required this.weekStart});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late List<List<String?>> _schedules;
  final ScrollController _hScroll = ScrollController();
  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();
    final existing = ScheduleStore.get(widget.weekStart);
    _schedules = existing != null
        ? existing.map((r) => List<String?>.from(r)).toList()
        : List.generate(_employees.length, (_) => List.filled(7, null));
  }

  @override
  void dispose() {
    _closeOverlay();
    _hScroll.dispose();
    super.dispose();
  }

  void _closeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _pickShift(int empIdx, int dayIdx, GlobalKey key) {
    _closeOverlay();
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
                onTap: _closeOverlay, behavior: HitTestBehavior.translucent),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 2,
            child: _ShiftDropdown(
              cellWidth: size.width,
              current: _schedules[empIdx][dayIdx],
              onSelected: (shift) {
                setState(() => _schedules[empIdx][dayIdx] = shift);
                _closeOverlay();
              },
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  Map<String, int> get _counts {
    final c = {for (var s in _shiftOptions) s: 0};
    for (final row in _schedules) {
      for (final s in row) {
        if (s != null) c[s] = (c[s] ?? 0) + 1;
      }
    }
    return c;
  }

  String _fmt(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    final weekEnd = widget.weekStart.add(const Duration(days: 6));
    final counts = _counts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text('Lịch Làm Việc Tuần',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            // Week navigator (display only)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('${_fmt(widget.weekStart)} –\n${_fmt(weekEnd)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('TUẦN HIỆN TẠI',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Hủy / Lưu thay đổi
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context: context,
                      title: 'Xác nhận hủy?',
                      message: 'Bạn có chắc chắn muốn hủy chỉnh sửa lịch làm này không? Hành động này không thể hoàn tác.',
                      cancelText: 'Không',
                      iconBgColor: const Color(0xFFEDE9FE),
                      iconColor: const Color(0xFF7C3AED),
                    );
                    if (confirmed) {
                      if (context.mounted) {
                        Navigator.pop(context, 'cancelled');
                      }
                    }
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B7280),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Hủy',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                      final confirmed = await showConfirmDialog(
                        context: context,
                        title: 'Xác nhận chỉnh sửa?',
                        message: 'Bạn có chắc chắn muốn chỉnh sửa lịch làm này không? Hành động này không thể hoàn tác.',
                      );
                      if (confirmed) {
                        ScheduleStore.save(widget.weekStart, _schedules);
                        if (context.mounted) {
                          showSuccessToast(context, 'Chỉnh sửa thành công');
                          await Future.delayed(const Duration(milliseconds: 800));
                        Navigator.pop(context, 'saved');
                        }
                      }
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Lưu thay đổi',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            // Table
            _buildTable(),
            const SizedBox(height: 12),
            // Summary
            _buildSummary(counts),
            const SizedBox(height: 12),
            const ShiftLegend(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(7)),
            child: const Center(
              child: Text('FP',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          const Text('FourPoint Hotel',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black)),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {}),
        Stack(
          children: [
            IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.black),
                onPressed: () {}),
            Positioned(
              right: 8, top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration:
                    const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Text('7',
                    style: TextStyle(color: Colors.white, fontSize: 9)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTable() {
    final totalHeight = _headerHeight + _rowHeight * _employees.length;
    return SizedBox(
      height: totalHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _nameColWidth,
            child: Column(children: [
              _nameHeader(),
              ...List.generate(_employees.length, _nameCell),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _hScroll,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _dayColWidth * _dayLabels.length,
                child: Column(children: [
                  _dayHeaderRow(),
                  ...List.generate(_employees.length, _dayRow),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameHeader() => Container(
        height: _headerHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: const Text('NHÂN VIÊN',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black45)),
      );

  Widget _nameCell(int i) => Container(
        height: _rowHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_employees[i].name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13),
                overflow: TextOverflow.ellipsis),
            Text(_employees[i].role,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      );

  Widget _dayHeaderRow() => SizedBox(
        height: _headerHeight,
        child: Row(
          children: _dayLabels
              .map((d) => Container(
                    width: _dayColWidth,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                    ),
                    alignment: Alignment.center,
                    child: Text(d,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0))),
                  ))
              .toList(),
        ),
      );

  Widget _dayRow(int empIdx) {
    return SizedBox(
      height: _rowHeight,
      child: Row(
        children: List.generate(_dayLabels.length, (dayIdx) {
          final shift = _schedules[empIdx][dayIdx];
          final key = GlobalKey();
          return GestureDetector(
            onTap: () => _pickShift(empIdx, dayIdx, key),
            child: Container(
              key: key,
              width: _dayColWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              alignment: Alignment.center,
              child: shift == null
                  ? Container(
                      width: 44, height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('---',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    )
                  : _badge(shift),
            ),
          );
        }),
      ),
    );
  }

  Widget _badge(String shift) {
    final bg = _shiftBg[shift] ?? Colors.grey;
    final fg = _shiftFg[shift] ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(shift,
          style: TextStyle(
              color: fg, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSummary(Map<String, int> counts) {
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
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _shiftOptions.map((s) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                        color: _shiftBg[s],
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(s,
                        style: TextStyle(
                            color: _shiftFg[s],
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 4),
                  Text('${counts[s] ?? 0}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 2,
      selectedItemColor: const Color(0xFF1565C0),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        BottomNavigationBarItem(
          icon: Stack(children: [
            const Icon(Icons.chat_bubble_outline),
            Positioned(
              right: 0, top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: const Text('3',
                    style: TextStyle(color: Colors.white, fontSize: 9)),
              ),
            ),
          ]),
          label: 'Tin nhắn',
        ),
        const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined), label: 'Lịch làm'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Tài khoản'),
      ],
    );
  }
}

// ── Shift Dropdown ────────────────────────────────────────────────────────────

class _ShiftDropdown extends StatelessWidget {
  final String? current;
  final double cellWidth;
  final ValueChanged<String?> onSelected;

  const _ShiftDropdown(
      {required this.current,
      required this.cellWidth,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: cellWidth,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._shiftOptions.map((s) {
              final bg = _shiftBg[s]!;
              final fg = _shiftFg[s]!;
              return GestureDetector(
                onTap: () => onSelected(s),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: current == s
                        ? Border.all(color: Colors.black26, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(s,
                      style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              );
            }),
            if (current != null) ...[
              const Divider(height: 6),
              GestureDetector(
                onTap: () => onSelected(null),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('Xóa ca',
                      style:
                          TextStyle(color: Colors.grey, fontSize: 11)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
