import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repositories/drift_craving_repository.dart';
import '../../domain/entities/craving_session.dart';
import '../../domain/repositories/craving_repository.dart';

final cravingClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final cravingRepositoryProvider = Provider<CravingRepository>((ref) {
  return DriftCravingRepository(ref.watch(appDatabaseProvider));
});

final cravingSessionsProvider = StreamProvider<List<CravingSession>>((ref) {
  return ref.watch(cravingRepositoryProvider).watchSessions();
});

final cravingSessionControllerProvider =
    AsyncNotifierProvider<CravingSessionController, CravingSession?>(
      CravingSessionController.new,
    );

class CravingSessionController extends AsyncNotifier<CravingSession?> {
  @override
  Future<CravingSession?> build() {
    return ref.read(cravingRepositoryProvider).getActiveSession();
  }

  Future<void> start({required int initialIntensity, String? note}) async {
    if (state.isLoading) {
      return;
    }
    final now = ref.read(cravingClockProvider)();
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(cravingRepositoryProvider)
          .startSession(
            StartCravingSessionInput(
              id: 'craving-${now.microsecondsSinceEpoch}',
              startedAt: now,
              initialIntensity: initialIntensity,
              note: note,
            ),
          ),
    );
  }

  Future<void> finish({
    required CravingOutcome outcome,
    int? finalIntensity,
  }) async {
    if (state.isLoading) {
      return;
    }
    final activeSession = state.valueOrNull;
    if (activeSession == null) {
      throw StateError('There is no active craving session to finish.');
    }
    final now = ref.read(cravingClockProvider)();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(cravingRepositoryProvider)
          .finishSession(
            FinishCravingSessionInput(
              sessionId: activeSession.id,
              endedAt: now,
              outcome: outcome,
              finalIntensity: finalIntensity,
            ),
          );
      return null;
    });
  }

  Future<void> extend({required int currentIntensity}) async {
    if (state.isLoading) {
      return;
    }
    final activeSession = state.valueOrNull;
    if (activeSession == null) {
      throw StateError('There is no active craving session to extend.');
    }
    final now = ref.read(cravingClockProvider)();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(cravingRepositoryProvider)
          .finishSession(
            FinishCravingSessionInput(
              sessionId: activeSession.id,
              endedAt: now,
              outcome: CravingOutcome.delayed,
              finalIntensity: currentIntensity,
            ),
          );
      return ref
          .read(cravingRepositoryProvider)
          .startSession(
            StartCravingSessionInput(
              id: 'craving-${now.microsecondsSinceEpoch}',
              startedAt: now,
              initialIntensity: currentIntensity,
            ),
          );
    });
  }
}
