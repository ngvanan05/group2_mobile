import 'package:flutter/material.dart';
import '../widgets/week_navigator.dart';
import '../widgets/schedule_table.dart';
import '../widgets/shift_summary.dart';
import '../widgets/shift_legend.dart';
import '../models/schedule_data.dart';
import '../widgets/success_toast.dart';
import '../widgets/confirm_dialog.dart';
import 'create_schedule_screen.dart';
import 'edit_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _weekStart = _currentWeekMonday();

  static DateTime _currentWeekMonday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
  }

  void _previousWeek() {
    setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
  }

  void _nextWeek() {
    // Chỉ cho xem tối đa 1 tuần sau tuần hiện tại
    final maxWeek = _currentWeekMonday().add(const Duration(days: 7));
    if (_weekStart.isBefore(maxWeek)) {
      setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));
    }
  }

  bool get _isCurrentWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final normalizedStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final normalizedWeek = DateTime(_weekStart.year, _weekStart.month, _weekStart.day);
    return normalizedStart == normalizedWeek;
  }

  // Chỉ cho tạo/sửa/xóa ở tuần hiện tại và 1 tuần sau
  bool get _canEdit {
    final current = _currentWeekMonday();
    final nextWeek = current.add(const Duration(days: 7));
    return _weekStart == current || _weekStart == nextWeek;
  }

  // Tuần đang xem đã có lịch chưa
  bool get _hasSchedule => ScheduleStore.has(_weekStart);

  // Tuần quá khứ (trước tuần hiện tại)
  bool get _isPastWeek => _weekStart.isBefore(_currentWeekMonday());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Lịch Làm Việc Tuần',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  WeekNavigator(
                    weekStart: _weekStart,
                    isCurrentWeek: _isCurrentWeek,
                    onPrevious: _previousWeek,
                    onNext: _nextWeek,
                  ),
                  if (!_isPastWeek) _buildActionButtons(),
                  ScheduleTable(weekStart: _weekStart),
                  const SizedBox(height: 12),
                  ShiftSummary(weekStart: _weekStart),
                  const SizedBox(height: 12),
                  const ShiftLegend(),
                  const SizedBox(height: 16),
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
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('FP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          const Text('FourPoint Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
        Stack(
          children: [
            IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black), onPressed: () {}),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Text('7', style: TextStyle(color: Colors.white, fontSize: 9)),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildActionButtons() {
    const btnRadius = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_hasSchedule && _canEdit)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateScheduleScreen(weekStart: _weekStart),
                      ),
                    );
                    if (!mounted) return;
                    if (result == 'saved') setState(() {});
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tạo lịch',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    shape: btnRadius,
                  ),
                ),
              ),
            if (!_hasSchedule && _canEdit) const SizedBox(width: 8),
            Expanded(
              child: TextButton.icon(
                onPressed: (_canEdit && _hasSchedule) ? () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditScheduleScreen(weekStart: _weekStart),
                    ),
                  );
                  if (!mounted) return;
                  if (result == 'saved') setState(() {});
                } : null,
                icon: Icon(Icons.edit_calendar_outlined,
                    size: 18, color: (_canEdit && _hasSchedule) ? const Color(0xFF166534) : Colors.grey),
                label: Text('Sửa lịch',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: (_canEdit && _hasSchedule) ? const Color(0xFF166534) : Colors.grey)),
                style: TextButton.styleFrom(
                  backgroundColor: (_canEdit && _hasSchedule) ? const Color(0xFFDCFCE7) : Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  shape: btnRadius,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextButton.icon(
                onPressed: (_canEdit && _hasSchedule) ? () async {
                  final confirmed = await showConfirmDialog(
                    context: context,
                    title: 'Xác nhận xóa?',
                    message: 'Bạn có chắc chắn muốn xóa lịch làm việc này không? Hành động này không thể hoàn tác.',
                    confirmText: 'Xóa',
                    iconBgColor: const Color(0xFFFFE4E6),
                    iconColor: const Color(0xFFDC2626),
                    confirmColor: const Color(0xFFDC2626),
                  );
                  if (!mounted) return;
                  if (confirmed) {
                    ScheduleStore.clear(_weekStart);
                    setState(() {});
                    showSuccessToast(context, 'Xóa lịch làm thành công');
                  }
                } : null,
                icon: Icon(Icons.delete_outline,
                    size: 18, color: (_canEdit && _hasSchedule) ? const Color(0xFF991B1B) : Colors.grey),
                label: Text('Xóa lịch',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: (_canEdit && _hasSchedule) ? const Color(0xFF991B1B) : Colors.grey)),
                style: TextButton.styleFrom(
                  backgroundColor: (_canEdit && _hasSchedule) ? const Color(0xFFFFE4E6) : Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  shape: btnRadius,
                ),
              ),
            ),
          ],
        ),
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
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.chat_bubble_outline),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9)),
                ),
              ),
            ],
          ),
          label: 'Tin nhắn',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Lịch làm'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Tài khoản'),
      ],
    );
  }
}
