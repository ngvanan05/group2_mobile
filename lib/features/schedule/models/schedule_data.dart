typedef WeekSchedule = List<List<String?>>;

const _shifts = ['M5', 'A1', 'E9', 'M6SS', 'DO'];
const _employeeCount = 7;

// Tạo lịch ngẫu nhiên nhưng cố định cho 1 tuần
WeekSchedule _fakeWeek(int seed) {
  final patterns = [
    ['M5', 'M5', 'A1', 'A1', 'E9', 'DO', 'DO'],
    ['A1', 'A1', 'M5', 'E9', 'E9', 'DO', 'M5'],
    ['E9', 'M5', 'M5', 'A1', 'DO', 'A1', 'E9'],
    ['DO', 'E9', 'A1', 'M5', 'M5', 'E9', 'A1'],
    ['M5', 'DO', 'E9', 'E9', 'A1', 'M5', 'DO'],
    ['A1', 'M5', 'DO', 'M6SS', 'M5', 'A1', 'E9'],
    ['M6SS', 'A1', 'M5', 'DO', 'E9', 'M6SS', 'M5'],
  ];
  return List.generate(_employeeCount, (i) {
    final pattern = patterns[(i + seed) % patterns.length];
    return List<String?>.from(pattern);
  });
}

class ScheduleStore {
  static final Map<DateTime, WeekSchedule> _data = {};
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;

    // Fake data cho 4 tuần trước
    final now = DateTime.now();
    final currentMonday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    for (int i = 1; i <= 4; i++) {
      final monday = currentMonday.subtract(Duration(days: 7 * i));
      _data[monday] = _fakeWeek(i);
    }
  }

  static WeekSchedule? get(DateTime weekMonday) => _data[weekMonday];

  static void save(DateTime weekMonday, WeekSchedule schedule) {
    _data[weekMonday] = schedule;
  }

  static void clear(DateTime weekMonday) {
    _data.remove(weekMonday);
  }

  static bool has(DateTime weekMonday) => _data.containsKey(weekMonday);
}
