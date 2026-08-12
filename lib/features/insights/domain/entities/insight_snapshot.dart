import '../../../../core/time/local_day.dart';
import '../../../craving/domain/entities/craving_session.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../quit_plan/domain/entities/quit_plan.dart';
import '../../../quit_plan/domain/entities/quit_progress.dart';
import '../../../smoking_log/domain/entities/smoking_log.dart';

class InsightSnapshot {
  const InsightSnapshot({
    required this.dailyCigarettes,
    required this.timeOfDayPatterns,
    required this.triggerUsage,
    required this.craving,
    required this.journey,
    required this.averageSmokingCraving,
  });

  final List<DailyCigaretteInsight> dailyCigarettes;
  final List<TimeOfDayInsight> timeOfDayPatterns;
  final List<TriggerInsight> triggerUsage;
  final CravingInsight craving;
  final JourneyInsight journey;
  final double? averageSmokingCraving;

  factory InsightSnapshot.calculate({
    required UserProfile profile,
    required Iterable<SmokingLog> smokingLogs,
    required Iterable<CravingSession> cravingSessions,
    required QuitPlan? quitPlan,
    required DateTime now,
    required int days,
  }) {
    assert(days > 0);
    final visibleLogs = smokingLogs.where((log) => !log.smokedAt.isAfter(now));
    final localToday = startOfLocalDay(now);
    final chartStart = DateTime(
      localToday.year,
      localToday.month,
      localToday.day - days + 1,
    );
    final countByDay = <DateTime, int>{};
    final timeBuckets = List<int>.filled(_timeBucketLabels.length, 0);
    final triggerCounts = <String, _TriggerAccumulator>{};
    var chartLogCount = 0;
    final smokingCravings = <int>[];

    for (final log in visibleLogs) {
      final localTime = log.smokedAt.toLocal();
      final day = DateTime(localTime.year, localTime.month, localTime.day);
      if (!day.isBefore(chartStart) && !day.isAfter(localToday)) {
        chartLogCount++;
        countByDay.update(day, (value) => value + 1, ifAbsent: () => 1);
        timeBuckets[_bucketIndexForHour(localTime.hour)]++;
        for (final trigger in log.triggers) {
          final accumulator = triggerCounts.putIfAbsent(
            trigger.id,
            () => _TriggerAccumulator(trigger.name),
          );
          accumulator.count++;
        }
      }
      if (log.cravingLevel != null) {
        smokingCravings.add(log.cravingLevel!);
      }
    }

    final dailyCigarettes = <DailyCigaretteInsight>[
      for (var offset = 0; offset < days; offset++)
        () {
          final day = DateTime(
            chartStart.year,
            chartStart.month,
            chartStart.day + offset,
          );
          return DailyCigaretteInsight(day: day, count: countByDay[day] ?? 0);
        }(),
    ];
    final timeOfDayPatterns = <TimeOfDayInsight>[
      for (var index = 0; index < _timeBucketLabels.length; index++)
        TimeOfDayInsight(
          label: _timeBucketLabels[index],
          count: timeBuckets[index],
        ),
    ];
    final triggerUsage =
        triggerCounts.entries
            .map(
              (entry) => TriggerInsight(
                id: entry.key,
                name: entry.value.name,
                count: entry.value.count,
                percentageOfLogs: chartLogCount == 0
                    ? 0
                    : entry.value.count / chartLogCount * 100,
              ),
            )
            .toList()
          ..sort((a, b) {
            final byCount = b.count.compareTo(a.count);
            return byCount == 0 ? a.name.compareTo(b.name) : byCount;
          });

    final completedSessions = cravingSessions
        .where(
          (session) =>
              !session.isActive &&
              session.endedAt != null &&
              !session.endedAt!.isAfter(now),
        )
        .toList();
    final completedInChartRange = completedSessions.where((session) {
      final day = startOfLocalDay(session.startedAt);
      return !day.isBefore(chartStart) && !day.isAfter(localToday);
    });
    final initialValues = completedSessions
        .map((session) => session.initialIntensity)
        .toList();
    final finalValues = completedSessions
        .map((session) => session.finalIntensity)
        .whereType<int>()
        .toList();
    final outcomeCounts = <CravingOutcome, int>{
      for (final outcome in CravingOutcome.values) outcome: 0,
    };
    for (final session in completedSessions) {
      outcomeCounts.update(session.outcome!, (value) => value + 1);
    }
    final cravingByDay = <DateTime, List<int>>{};
    for (final session in completedInChartRange) {
      final day = startOfLocalDay(session.startedAt);
      cravingByDay.putIfAbsent(day, () => []).add(session.initialIntensity);
    }
    final cravingTrend = <CravingTrendPoint>[
      for (final dayPoint in dailyCigarettes)
        CravingTrendPoint(
          day: dayPoint.day,
          averageInitialIntensity: _average(
            cravingByDay[dayPoint.day] ?? const [],
          ),
        ),
    ];

    return InsightSnapshot(
      dailyCigarettes: dailyCigarettes,
      timeOfDayPatterns: timeOfDayPatterns,
      triggerUsage: triggerUsage,
      craving: CravingInsight(
        averageInitialIntensity: _average(initialValues),
        averageFinalIntensity: _average(finalValues),
        outcomes: outcomeCounts,
        trend: cravingTrend,
        totalCompleted: completedSessions.length,
      ),
      journey: JourneyInsight.calculate(
        profile: profile,
        smokingLogs: visibleLogs,
        quitPlan: quitPlan,
        now: now,
        totalCravingSessionsCompleted: completedSessions.length,
      ),
      averageSmokingCraving: _average(smokingCravings),
    );
  }

  static const _timeBucketLabels = <String>[
    '00–06',
    '06–09',
    '09–12',
    '12–15',
    '15–18',
    '18–21',
    '21–24',
  ];

  static int _bucketIndexForHour(int hour) => switch (hour) {
    < 6 => 0,
    < 9 => 1,
    < 12 => 2,
    < 15 => 3,
    < 18 => 4,
    < 21 => 5,
    _ => 6,
  };
}

class DailyCigaretteInsight {
  const DailyCigaretteInsight({required this.day, required this.count});

  final DateTime day;
  final int count;
}

class TimeOfDayInsight {
  const TimeOfDayInsight({required this.label, required this.count});

  final String label;
  final int count;
}

class TriggerInsight {
  const TriggerInsight({
    required this.id,
    required this.name,
    required this.count,
    required this.percentageOfLogs,
  });

  final String id;
  final String name;
  final int count;
  final double percentageOfLogs;
}

class CravingInsight {
  const CravingInsight({
    required this.averageInitialIntensity,
    required this.averageFinalIntensity,
    required this.outcomes,
    required this.trend,
    required this.totalCompleted,
  });

  final double? averageInitialIntensity;
  final double? averageFinalIntensity;
  final Map<CravingOutcome, int> outcomes;
  final List<CravingTrendPoint> trend;
  final int totalCompleted;
}

class CravingTrendPoint {
  const CravingTrendPoint({
    required this.day,
    required this.averageInitialIntensity,
  });

  final DateTime day;
  final double? averageInitialIntensity;
}

class JourneyInsight {
  const JourneyInsight({
    required this.currentSmokeFreeDuration,
    required this.longestSmokeFreeDuration,
    required this.cigarettesAvoided,
    required this.daysBelowBaseline,
    required this.moneyNotSpent,
    required this.totalCravingSessionsCompleted,
  });

  final Duration? currentSmokeFreeDuration;
  final Duration? longestSmokeFreeDuration;
  final int cigarettesAvoided;
  final int daysBelowBaseline;
  final double? moneyNotSpent;
  final int totalCravingSessionsCompleted;

  factory JourneyInsight.calculate({
    required UserProfile profile,
    required Iterable<SmokingLog> smokingLogs,
    required QuitPlan? quitPlan,
    required DateTime now,
    required int totalCravingSessionsCompleted,
  }) {
    final activePlan = quitPlan?.status == QuitPlanStatus.active
        ? quitPlan
        : null;
    final start = startOfLocalDay(activePlan?.quitDate ?? profile.createdAt);
    final end = startOfLocalDay(now);
    final completedDays = end.isAfter(start) ? end.difference(start).inDays : 0;
    final countByDay = <DateTime, int>{};
    for (final log in smokingLogs) {
      final day = startOfLocalDay(log.smokedAt);
      if (!day.isBefore(start) && day.isBefore(end)) {
        countByDay.update(day, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    var daysBelowBaseline = 0;
    for (var offset = 0; offset < completedDays; offset++) {
      final day = DateTime(start.year, start.month, start.day + offset);
      if ((countByDay[day] ?? 0) < profile.baselineCigarettesPerDay) {
        daysBelowBaseline++;
      }
    }
    final rawAvoided =
        profile.baselineCigarettesPerDay * completedDays -
        countByDay.values.fold<int>(0, (sum, count) => sum + count);
    final avoided = rawAvoided < 0 ? 0 : rawAvoided;
    final validPrice = profile.packPrice != null && profile.packPrice! > 0;
    final validPackSize =
        profile.cigarettesPerPack != null && profile.cigarettesPerPack! > 0;
    final progress = activePlan == null
        ? null
        : QuitProgress.calculate(
            plan: activePlan,
            smokingEvents: smokingLogs.map((log) => log.smokedAt),
            now: now,
          );
    return JourneyInsight(
      currentSmokeFreeDuration: progress?.currentSmokeFreeDuration,
      longestSmokeFreeDuration: progress?.longestSmokeFreeDuration,
      cigarettesAvoided: avoided,
      daysBelowBaseline: daysBelowBaseline,
      moneyNotSpent: validPrice && validPackSize
          ? avoided * profile.packPrice! / profile.cigarettesPerPack!
          : null,
      totalCravingSessionsCompleted: totalCravingSessionsCompleted,
    );
  }
}

class _TriggerAccumulator {
  _TriggerAccumulator(this.name);

  final String name;
  int count = 0;
}

double? _average(Iterable<int> values) {
  if (values.isEmpty) {
    return null;
  }
  final sum = values.fold<int>(0, (total, value) => total + value);
  return sum / values.length;
}
