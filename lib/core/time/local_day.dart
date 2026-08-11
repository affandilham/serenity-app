DateTime startOfLocalDay(DateTime instant) {
  final local = instant.toLocal();
  return DateTime(local.year, local.month, local.day);
}

DateTime startOfNextLocalDay(DateTime instant) {
  final start = startOfLocalDay(instant);
  return DateTime(start.year, start.month, start.day + 1);
}

bool isOnLocalDay(DateTime instant, DateTime day) {
  final local = instant.toLocal();
  final localDay = day.toLocal();
  return local.year == localDay.year &&
      local.month == localDay.month &&
      local.day == localDay.day;
}
