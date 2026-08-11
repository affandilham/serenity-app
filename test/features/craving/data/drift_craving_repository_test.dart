import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/features/craving/data/repositories/drift_craving_repository.dart';
import 'package:serenity_app/features/craving/domain/entities/craving_session.dart';
import 'package:serenity_app/features/smoking_log/data/repositories/drift_smoking_log_repository.dart';
import 'package:serenity_app/features/smoking_log/domain/entities/smoking_log.dart';

void main() {
  late AppDatabase database;
  late DriftCravingRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftCravingRepository(database);
  });

  tearDown(() => database.close());

  test(
    'persists a started session and every supported completion outcome',
    () async {
      final startedAt = DateTime(2026, 8, 11, 10);
      for (final outcome in CravingOutcome.values) {
        final id = 'session-${outcome.name}';
        final started = await repository.startSession(
          StartCravingSessionInput(
            id: id,
            startedAt: startedAt,
            initialIntensity: 4,
            note: '  after coffee  ',
          ),
        );

        expect(started.startedAt, startedAt);
        expect(started.initialIntensity, 4);
        expect(started.note, 'after coffee');
        expect((await repository.getActiveSession())?.id, id);

        final finished = await repository.finishSession(
          FinishCravingSessionInput(
            sessionId: id,
            endedAt: startedAt.add(const Duration(minutes: 5)),
            outcome: outcome,
            finalIntensity: outcome == CravingOutcome.abandoned ? null : 2,
          ),
        );

        expect(finished.outcome, outcome);
        expect(finished.endedAt, startedAt.add(const Duration(minutes: 5)));
        expect(
          finished.finalIntensity,
          outcome == CravingOutcome.abandoned ? null : 2,
        );
        expect(await repository.getActiveSession(), isNull);
      }

      final sessions = await repository.watchSessions().first;
      expect(sessions, hasLength(CravingOutcome.values.length));
    },
  );

  test(
    'a smoked craving outcome leaves existing smoking history untouched',
    () async {
      final smokingRepository = DriftSmokingLogRepository(database);
      final time = DateTime(2026, 8, 11, 10);
      await smokingRepository.addLog(
        CreateSmokingLogInput(
          id: 'existing-smoking-log',
          smokedAt: time,
          createdAt: time,
        ),
      );
      await repository.startSession(
        StartCravingSessionInput(
          id: 'smoked-session',
          startedAt: time.add(const Duration(minutes: 1)),
          initialIntensity: 5,
        ),
      );

      await repository.finishSession(
        FinishCravingSessionInput(
          sessionId: 'smoked-session',
          endedAt: time.add(const Duration(minutes: 6)),
          finalIntensity: 5,
          outcome: CravingOutcome.smoked,
        ),
      );

      final logs = await smokingRepository.watchLogs().first;
      expect(logs.map((log) => log.id), ['existing-smoking-log']);
    },
  );
}
