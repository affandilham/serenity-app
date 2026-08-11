import '../../../../core/time/local_day.dart';
import 'quit_plan.dart';

class QuitProgress {
  const QuitProgress({
    required this.currentSmokeFreeDuration,
    required this.longestSmokeFreeDuration,
    required this.lastCigaretteAt,
  });

  final Duration currentSmokeFreeDuration;
  final Duration longestSmokeFreeDuration;
  final DateTime? lastCigaretteAt;

  factory QuitProgress.calculate({
    required QuitPlan plan,
    required Iterable<DateTime> smokingEvents,
    required DateTime now,
  }) {
    final quitStart = startOfLocalDay(plan.quitDate);
    final allEvents =
        smokingEvents.where((event) => !event.isAfter(now)).toList()..sort();
    final events = allEvents.where((event) => !event.isBefore(quitStart));

    var intervalStart = quitStart;
    var longest = Duration.zero;
    final lastCigarette = allEvents.isEmpty ? null : allEvents.last;
    for (final event in events) {
      final interval = event.difference(intervalStart);
      if (interval > longest) {
        longest = interval;
      }
      intervalStart = event;
    }
    final currentStart = lastCigarette ?? quitStart;
    final current = now.isBefore(currentStart)
        ? Duration.zero
        : now.difference(currentStart);
    if (current > longest) {
      longest = current;
    }
    return QuitProgress(
      currentSmokeFreeDuration: current,
      longestSmokeFreeDuration: longest,
      lastCigaretteAt: lastCigarette,
    );
  }
}

bool isQuitDateReached({required DateTime quitDate, required DateTime now}) {
  return !startOfLocalDay(now).isBefore(startOfLocalDay(quitDate));
}

bool isSlipForPlan({required QuitPlan plan, required DateTime smokedAt}) {
  return plan.status == QuitPlanStatus.active &&
      !smokedAt.isBefore(startOfLocalDay(plan.quitDate));
}

bool canTransitionQuitPlan({
  required QuitPlanStatus from,
  required QuitPlanStatus to,
}) {
  return switch ((from, to)) {
    (QuitPlanStatus.draft, QuitPlanStatus.active) => true,
    (QuitPlanStatus.active, QuitPlanStatus.paused) => true,
    (QuitPlanStatus.active, QuitPlanStatus.completed) => true,
    (QuitPlanStatus.paused, QuitPlanStatus.active) => true,
    _ => false,
  };
}
