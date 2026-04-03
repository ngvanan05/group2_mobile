import 'package:flutter/material.dart';
import '../widgets/shift_legend.dart';
import '../widgets/week_picker.dart';
import '../models/schedule_data.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/success_toast.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _Employee {
  final String name;
  final String role;
  final Color avatarColor;

  const _Employee({required this.name, required this.role, required this.avatarColor});

  String get initial => name.trim().split(' ').last[0].toUpperCase();
}

const List<_Employee> _employees = [
  _Employee(name: 'Đại Trung Tuấn',      role: 'Bảo vệ',              avatarColor: Color(0xFF5C6BC0)),
  _Employee(name: 'Hoàng Hải Yến',        role: 'Lễ tân',              avatarColor: Color(0xFF26A69A)),
  _Employee(name: 'Nguyễn Lê Bảo Hân',   role: 'Lễ tân',              avatarColor: Color(0xFFEF5350)),
  _Employee(name: 'Vũ Nguyễn Đức Trinh', role: 'Lễ tân',              avatarColor: Color(0xFF5C6BC0)),
  _Employee(name: 'Dương Thị Quỳnh',      role: 'Lễ tân',              avatarColor: Color(0xFFFF7043)),
  _Employee(name: 'Lê Quang Hải',         role: 'Chuyên viên bảo trì', avatarColor: Color(0xFFAB47BC)),
  _Employee(name: 'Hoài Lâm',             role: 'Lễ tân',              avatarColor: Color(0xFF26C6DA)),
  _Employee(name: 'Nguyễn Lê Minh Châu', role: 'Lễ tân',              avatarColor: Color(0xFF66BB6A)),
  _Employee(name: 'Nguyễn Thị Ánh Thu',  role: 'Lễ tân',              avatarColor: Color(0xFF5C6BC0)),
  _Employee(name: 'Lê Hoàng Bảo Châu',   role: 'Lễ tân',              avatarColor: Color(0xFF66BB6A)),
  _Employee(name: 'Phạm Phú Huyền',       role: 'Lễ tân',              avatarColor: Color(0xFF42A5F5)),
  _Employee(name: 'Lê Ánh Nguyệt',        role: 'Lễ tân',              avatarColor: Color(0xFFEC407A)),
];

const List<String> _dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
const List<String> _shiftOptions = ['M5', 'A1', 'E9', 'M6SS', 'DO'];
const Map<String, Color> _shiftColors = {
  'M5':   Color(0xFFC084FC),
  'A1':   Color(0xFF93C5FD),
  'E9':   Color(0xFFFDBA74),
  'M6SS': Color(0xFFFCD34D),
  'DO':   Color(0xFFFCA5A5),
};

const Map<String, Color> _shiftTextColors = {
  'M5':   Color(0xFF6B21A8),
  'A1':   Color(0xFF1D4ED8),
  'E9':   Color(0xFFC2410C),
  'M6SS': Color(0xFF92400E),
  'DO':   Color(0xFFB91C1C),
};

const double _nameColWidth = 160.0;
const double _dayColWidth  = 54.0;
const double _rowHeight    = 64.0;
const double _headerHeight = 36.0;

// ── Screen ────────────────────────────────────────────────────────────────────

class CreateScheduleScreen extends StatefulWidget {
  final DateTime weekStart;
  const CreateScheduleScreen({super.key, required this.weekStart});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  late List<List<String?>> _schedules;
  final ScrollController _hScroll = ScrollController();
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _weekStart = weekMonday(widget.weekStart);
    _schedules = List.generate(_employees.length, (_) => List.filled(7, null));
  }

  Map<String, int> get _shiftCounts {
    final counts = {for (var s in _shiftOptions) s: 0};
    for (final row in _schedules) {
      for (final shift in row) {
        if (shift != null) counts[shift] = (counts[shift] ?? 0) + 1;
      }
    }
    return counts;
  }

  OverlayEntry? _overlayEntry;

  void _pickShift(int empIdx, int dayIdx, GlobalKey cellKey) {
    _closeOverlay();

    final box = cellKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // tap outside to close
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeOverlay,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: offset.dx + (size.width - 52) / 2,
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
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _closeOverlay();
    _hScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counts = _shiftCounts;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildWeekSelector(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStickyTable(),
                  _buildBottom(counts),
                ],
              ),
            ),
          ),
        ],
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
                color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(7)),
            child: const Center(
              child: Text('FP',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          const Text('FourPoint Hotel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
        Stack(
          children: [
            IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black),
                onPressed: () {}),
            Positioned(
              right: 8, top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Text('7', style: TextStyle(color: Colors.white, fontSize: 9)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekSelector() {
    final weekNum = _isoWeekNum(_weekStart);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quản lý lịch làm việc của nhân viên theo tuần',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Chọn tuần: ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () async {
                  final picked = await showWeekPicker(
                    context: context,
                    initialWeek: _weekStart,
                  );
                  if (picked != null) setState(() => _weekStart = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: [
                      Text('Week ${weekNum.toString().padLeft(2, '0')}, ${_weekStart.year}',
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _isoWeekNum(DateTime date) {
    final thu = date.add(Duration(days: 4 - date.weekday));
    final firstThu = DateTime(thu.year, 1, 1);
    return 1 + ((thu.difference(firstThu).inDays) / 7).floor();
  }

  Widget _buildStickyTable() {
    // Tính chiều cao cố định để không cần scroll dọc bên trong
    final totalHeight = _headerHeight + _rowHeight * _employees.length;
    return SizedBox(
      height: totalHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed left column
          SizedBox(
            width: _nameColWidth,
            child: Column(
              children: [
                _nameHeader(),
                ...List.generate(_employees.length, (i) => _nameCell(i)),
              ],
            ),
          ),
          // Scrollable day columns
          Expanded(
            child: SingleChildScrollView(
              controller: _hScroll,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _dayColWidth * _dayLabels.length,
                child: Column(
                  children: [
                    _dayHeaderRow(),
                    ...List.generate(_employees.length, (i) => _dayRow(i)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameHeader() {
    return Container(
      height: _headerHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: const Text('NHÂN VIÊN',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black45)),
    );
  }

  Widget _nameCell(int i) {
    final emp = _employees[i];
    return Container(
      height: _rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: emp.avatarColor,
            child: Text(emp.initial,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emp.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    overflow: TextOverflow.ellipsis),
                Text(emp.role,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayHeaderRow() {
    return SizedBox(
      height: _headerHeight,
      child: Row(
        children: _dayLabels.map((d) => Container(
          width: _dayColWidth,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          alignment: Alignment.center,
          child: Text(d,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
        )).toList(),
      ),
    );
  }

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
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              alignment: Alignment.center,
              child: shift == null
                  ? Container(
                      width: 44,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('---',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    )
                  : _ShiftBadge(shift: shift),
            ),
          );
        }),
      ),
    );
  }

  // ── Bottom bar ───────────────────────────────────────────────────────────────
  Widget _buildBottom(Map<String, int> counts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Container(
          color: const Color(0xFF1E1B4B),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TỔNG SỐ CA LÀM VIỆC',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _shiftOptions.map((s) {
                  final bg = _shiftColors[s]!;
                  final fg = _shiftTextColors[s]!;
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            color: bg, borderRadius: BorderRadius.circular(5)),
                        child: Text(s,
                            style: TextStyle(
                              color: fg, fontSize: 9, fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(width: 4),
                      Text('${counts[s] ?? 0}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context: context,
                      title: 'Xác nhận hủy?',
                      message: 'Bạn có chắc chắn muốn hủy tạo lịch làm này không? Hành động này không thể hoàn tác.',
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
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B7280),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Hủy tạo',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context: context,
                      title: 'Xác nhận lưu lịch?',
                      message: 'Bạn có chắc chắn muốn lưu lịch làm này không?',
                    );
                    if (confirmed) {
                      ScheduleStore.save(_weekStart, _schedules);
                      if (context.mounted) {
                        showSuccessToast(context, 'Thêm lịch thành công');
                        await Future.delayed(const Duration(milliseconds: 800));
                        Navigator.pop(context, 'saved');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Lưu lịch làm việc',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const ShiftLegend(),
        const SizedBox(height: 10),
      ],
    );
  }
}

// ── Shift Badge ───────────────────────────────────────────────────────────────

class _ShiftBadge extends StatelessWidget {
  final String shift;
  const _ShiftBadge({required this.shift});

  @override
  Widget build(BuildContext context) {
    final bg = _shiftColors[shift] ?? Colors.grey;
    final fg = _shiftTextColors[shift] ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(shift,
          style: TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

// ── Shift Dropdown Overlay ────────────────────────────────────────────────────

class _ShiftDropdown extends StatelessWidget {
  final String? current;
  final double cellWidth;
  final ValueChanged<String?> onSelected;

  const _ShiftDropdown({required this.current, required this.cellWidth, required this.onSelected});

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
              final bg = _shiftColors[s]!;
              final fg = _shiftTextColors[s]!;
              final isSelected = current == s;
              return GestureDetector(
                onTap: () => onSelected(s),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: Colors.black26, width: 2) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(s,
                      style: TextStyle(
                          color: fg, fontWeight: FontWeight.bold, fontSize: 13)),
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
                      style: TextStyle(color: Colors.grey, fontSize: 11)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
