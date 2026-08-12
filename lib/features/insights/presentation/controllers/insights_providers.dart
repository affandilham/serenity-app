import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../craving/presentation/controllers/craving_providers.dart';
import '../../../onboarding/presentation/controllers/onboarding_providers.dart';
import '../../../quit_plan/presentation/controllers/quit_plan_providers.dart';
import '../../domain/entities/insight_snapshot.dart';

final insightsClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final insightsRangeDaysProvider = NotifierProvider<InsightsRangeNotifier, int>(
  InsightsRangeNotifier.new,
);

class InsightsRangeNotifier extends Notifier<int> {
  @override
  int build() => 7;

  void select(int days) {
    if (days != 7 && days != 30) {
      throw ArgumentError.value(
        days,
        'days',
        'Only 7 or 30 days are supported.',
      );
    }
    state = days;
  }
}

final insightsSnapshotProvider = Provider<InsightSnapshot?>((ref) {
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final logs = ref.watch(allSmokingLogsProvider).valueOrNull;
  final cravings = ref.watch(cravingSessionsProvider).valueOrNull;
  if (profile == null || logs == null || cravings == null) {
    return null;
  }
  return InsightSnapshot.calculate(
    profile: profile,
    smokingLogs: logs,
    cravingSessions: cravings,
    quitPlan: ref.watch(quitPlanProvider).valueOrNull,
    now: ref.watch(insightsClockProvider)(),
    days: ref.watch(insightsRangeDaysProvider),
  );
});
