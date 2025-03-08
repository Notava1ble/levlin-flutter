import 'package:levlin/models/quest.dart';

int getNeededXpFromLevel(int level) {
  if (level < 1) {
    return 0;
  } else if (level <= 15) {
    return level * (level + 7);
  } else if (level <= 30) {
    return (2.5 * level * level - 38 * level + 337.5).floor();
  } else {
    return (4.5 * level * level - 158 * level + 2137.5).floor();
  }
}

int getProgressForToday(Quest quest) {
  DateTime today = DateTime.now();

  for (var entry in quest.completions) {
    if (_isSameDay(entry.day, today)) {
      return entry.count;
    }
  }

  return 0;
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
