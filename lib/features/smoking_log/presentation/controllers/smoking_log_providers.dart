import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/time/local_day.dart';
import '../../data/repositories/drift_smoking_log_repository.dart';
import '../../domain/entities/smoking_log.dart';
import '../../domain/repositories/smoking_log_repository.dart';

final smokingLogClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final smokingLogRepositoryProvider = Provider<SmokingLogRepository>((ref) {
  return DriftSmokingLogRepository(ref.watch(appDatabaseProvider));
});

final triggerTagsProvider = StreamProvider<List<TriggerTag>>((ref) {
  return ref.watch(smokingLogRepositoryProvider).watchTriggers();
});

final todaySmokingCountProvider = StreamProvider<int>((ref) {
  final now = ref.watch(smokingLogClockProvider)();
  return ref.watch(smokingLogRepositoryProvider).watchCountForDay(now);
});

final todaySmokingLogsProvider = StreamProvider<List<SmokingLog>>((ref) {
  final now = ref.watch(smokingLogClockProvider)();
  return ref
      .watch(smokingLogRepositoryProvider)
      .watchLogs(from: startOfLocalDay(now), to: startOfNextLocalDay(now));
});

final smokingLogControllerProvider =
    AsyncNotifierProvider<SmokingLogController, void>(SmokingLogController.new);

class SmokingLogController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> addQuickLog({
    required Set<String> triggerIds,
    int? cravingLevel,
    String? note,
  }) async {
    if (state.isLoading) {
      return;
    }
    final now = ref.read(smokingLogClockProvider)();
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(smokingLogRepositoryProvider)
          .addLog(
            CreateSmokingLogInput(
              id: 'smoking-${now.microsecondsSinceEpoch}',
              smokedAt: now,
              createdAt: now,
              cravingLevel: cravingLevel,
              note: note,
              triggerIds: triggerIds,
            ),
          ),
    );
  }
}
