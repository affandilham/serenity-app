import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/database/database_provider.dart';
import 'package:serenity_app/features/craving/domain/entities/craving_session.dart';
import 'package:serenity_app/features/craving/presentation/controllers/craving_providers.dart';

void main() {
  test(
    'controller transitions from no session to active then passed',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      var now = DateTime(2026, 8, 11, 10);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          cravingClockProvider.overrideWithValue(() => now),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(database.close);

      await container.read(cravingSessionControllerProvider.future);
      expect(
        container.read(cravingSessionControllerProvider).valueOrNull,
        isNull,
      );

      await container
          .read(cravingSessionControllerProvider.notifier)
          .start(initialIntensity: 4);
      final active = container
          .read(cravingSessionControllerProvider)
          .valueOrNull;
      expect(active?.isActive, isTrue);
      expect(active?.startedAt, now);
      expect(active?.initialIntensity, 4);

      now = now.add(const Duration(minutes: 5));
      await container
          .read(cravingSessionControllerProvider.notifier)
          .finish(outcome: CravingOutcome.passed, finalIntensity: 1);

      expect(
        container.read(cravingSessionControllerProvider).valueOrNull,
        isNull,
      );
      final stored = await database
          .select(database.cravingSessions)
          .getSingle();
      expect(stored.outcome, 'passed');
      expect(stored.finalIntensity, 1);
      expect(stored.endedAt, now);
    },
  );

  test(
    'controller records delayed before beginning another five minutes',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      var now = DateTime(2026, 8, 11, 10);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          cravingClockProvider.overrideWithValue(() => now),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(database.close);

      await container.read(cravingSessionControllerProvider.future);
      await container
          .read(cravingSessionControllerProvider.notifier)
          .start(initialIntensity: 5);
      final firstSession = container
          .read(cravingSessionControllerProvider)
          .valueOrNull!;

      now = now.add(const Duration(minutes: 5));
      await container
          .read(cravingSessionControllerProvider.notifier)
          .extend(currentIntensity: 2);

      final activeSession = container
          .read(cravingSessionControllerProvider)
          .valueOrNull!;
      expect(activeSession.id, isNot(firstSession.id));
      expect(activeSession.initialIntensity, 2);
      expect(activeSession.startedAt, now);

      final sessions = await database.select(database.cravingSessions).get();
      final delayedSession = sessions.singleWhere(
        (row) => row.id == firstSession.id,
      );
      expect(delayedSession.outcome, 'delayed');
      expect(delayedSession.finalIntensity, 2);
    },
  );
}
