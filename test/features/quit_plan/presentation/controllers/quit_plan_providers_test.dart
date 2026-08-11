import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/database/database_provider.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_plan.dart';
import 'package:serenity_app/features/quit_plan/presentation/controllers/quit_plan_providers.dart';
import 'package:serenity_app/features/smoking_log/data/repositories/drift_smoking_log_repository.dart';

void main() {
  test(
    'activates a due plan and keeps smoking and craving history after a slip',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      var now = DateTime(2026, 8, 12, 9);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          quitPlanClockProvider.overrideWithValue(() => now),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(database.close);
      await database
          .into(database.motivations)
          .insert(
            MotivationsCompanion.insert(
              id: 'why',
              content: 'Keluarga',
              category: 'Keluarga',
              createdAt: now,
            ),
          );
      await DriftSmokingLogRepository(database).watchTriggers().first;
      await container.read(quitPlanControllerProvider.future);

      await container
          .read(quitPlanControllerProvider.notifier)
          .save(
            SaveQuitPlanInput(
              quitDate: DateTime(2026, 8, 12),
              primaryMotivationId: 'why',
              supportPerson: null,
              strategies: const [],
            ),
          );
      expect(
        container.read(quitPlanControllerProvider).valueOrNull?.status,
        QuitPlanStatus.active,
      );

      await container.read(quitPlanControllerProvider.notifier).pause();
      expect(
        container.read(quitPlanControllerProvider).valueOrNull?.status,
        QuitPlanStatus.paused,
      );
      await container.read(quitPlanControllerProvider.notifier).resume();

      await database
          .into(database.smokingLogs)
          .insert(
            SmokingLogsCompanion.insert(
              id: 'slip-log',
              smokedAt: now,
              createdAt: now,
            ),
          );
      await database
          .into(database.cravingSessions)
          .insert(
            CravingSessionsCompanion.insert(
              id: 'craving-before-slip',
              startedAt: now.subtract(const Duration(minutes: 5)),
              initialIntensity: 4,
              endedAt: Value(now),
              finalIntensity: const Value(1),
              outcome: const Value('passed'),
            ),
          );

      expect(
        await container
            .read(quitPlanControllerProvider.notifier)
            .assessSmokingEvent(now),
        isTrue,
      );
      expect(await database.select(database.smokingLogs).get(), hasLength(1));
      expect(
        await database.select(database.cravingSessions).get(),
        hasLength(1),
      );
      expect(
        container.read(quitPlanControllerProvider).valueOrNull?.status,
        QuitPlanStatus.active,
      );
    },
  );
}
