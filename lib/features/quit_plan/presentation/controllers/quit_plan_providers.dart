import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../smoking_log/presentation/controllers/smoking_log_providers.dart';
import '../../data/repositories/drift_quit_plan_repository.dart';
import '../../domain/entities/quit_plan.dart';
import '../../domain/entities/quit_progress.dart';
import '../../domain/repositories/quit_plan_repository.dart';

final quitPlanClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final quitPlanRepositoryProvider = Provider<QuitPlanRepository>((ref) {
  return DriftQuitPlanRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(quitPlanClockProvider),
  );
});

final quitPlanProvider = StreamProvider<QuitPlan?>((ref) {
  return ref.watch(quitPlanRepositoryProvider).watchPlan();
});

final allSmokingLogsProvider = StreamProvider((ref) {
  return ref.watch(smokingLogRepositoryProvider).watchLogs();
});

final quitProgressProvider = Provider<QuitProgress?>((ref) {
  final plan = ref.watch(quitPlanProvider).valueOrNull;
  final logs = ref.watch(allSmokingLogsProvider).valueOrNull;
  if (plan == null || logs == null || plan.status != QuitPlanStatus.active) {
    return null;
  }
  return QuitProgress.calculate(
    plan: plan,
    smokingEvents: logs.map((log) => log.smokedAt),
    now: ref.watch(quitPlanClockProvider)(),
  );
});

final quitPlanControllerProvider =
    AsyncNotifierProvider<QuitPlanController, QuitPlan?>(
      QuitPlanController.new,
    );

class QuitPlanController extends AsyncNotifier<QuitPlan?> {
  @override
  Future<QuitPlan?> build() => ref.read(quitPlanRepositoryProvider).getPlan();

  Future<void> save(SaveQuitPlanInput input) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final plan = await ref.read(quitPlanRepositoryProvider).savePlan(input);
      return _activateIfDue(plan);
    });
  }

  Future<void> activateIfDue() async {
    final current =
        state.valueOrNull ??
        await ref.read(quitPlanRepositoryProvider).getPlan();
    if (current == null) {
      return;
    }
    state = AsyncData(await _activateIfDue(current));
  }

  Future<void> pause() => _transition(QuitPlanStatus.paused);

  Future<void> resume() => _transition(QuitPlanStatus.active);

  Future<bool> assessSmokingEvent(DateTime smokedAt) async {
    final current =
        state.valueOrNull ??
        await ref.read(quitPlanRepositoryProvider).getPlan();
    if (current == null) {
      return false;
    }
    final plan = await _activateIfDue(current);
    state = AsyncData(plan);
    return isSlipForPlan(plan: plan, smokedAt: smokedAt);
  }

  Future<QuitPlan> _activateIfDue(QuitPlan plan) async {
    final now = ref.read(quitPlanClockProvider)();
    if (plan.status == QuitPlanStatus.draft &&
        isQuitDateReached(quitDate: plan.quitDate, now: now)) {
      return ref
          .read(quitPlanRepositoryProvider)
          .transitionPlan(
            planId: plan.id,
            status: QuitPlanStatus.active,
            updatedAt: now,
          );
    }
    return plan;
  }

  Future<void> _transition(QuitPlanStatus status) async {
    final current =
        state.valueOrNull ??
        await ref.read(quitPlanRepositoryProvider).getPlan();
    if (current == null) {
      throw StateError('There is no quit plan to update.');
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(quitPlanRepositoryProvider)
          .transitionPlan(
            planId: current.id,
            status: status,
            updatedAt: ref.read(quitPlanClockProvider)(),
          ),
    );
  }
}
