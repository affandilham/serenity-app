import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/features/quit_plan/data/repositories/drift_quit_plan_repository.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_plan.dart';
import 'package:serenity_app/features/smoking_log/data/repositories/drift_smoking_log_repository.dart';

void main() {
  late AppDatabase database;
  late DriftQuitPlanRepository repository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftQuitPlanRepository(
      database,
      clock: () => DateTime(2026, 8, 11, 9),
    );
    await database
        .into(database.motivations)
        .insert(
          MotivationsCompanion.insert(
            id: 'why-family',
            content: 'Keluarga',
            category: 'Keluarga',
            createdAt: DateTime(2026, 8, 1),
          ),
        );
    await DriftSmokingLogRepository(database).watchTriggers().first;
  });

  tearDown(() => database.close());

  test(
    'creates, edits, and persists a plan with normalized strategies',
    () async {
      final created = await repository.savePlan(
        SaveQuitPlanInput(
          quitDate: DateTime(2026, 8, 12),
          primaryMotivationId: 'why-family',
          supportPerson: '  Rani  ',
          strategies: const [
            SaveQuitPlanStrategyInput(
              triggerId: 'coffee',
              action: 'Minum di tempat berbeda',
            ),
            SaveQuitPlanStrategyInput(action: 'Buka SOS lalu minum air'),
          ],
        ),
      );

      expect(created.status, QuitPlanStatus.draft);
      expect(created.primaryMotivation?.text, 'Keluarga');
      expect(created.supportPerson, 'Rani');
      expect(created.strategies, hasLength(2));
      expect(
        created.strategies
            .singleWhere((item) => item.trigger != null)
            .trigger
            ?.id,
        'coffee',
      );

      final active = await repository.transitionPlan(
        planId: created.id,
        status: QuitPlanStatus.active,
        updatedAt: DateTime(2026, 8, 12),
      );
      final edited = await repository.savePlan(
        SaveQuitPlanInput(
          id: active.id,
          quitDate: DateTime(2026, 8, 13),
          primaryMotivationId: 'why-family',
          supportPerson: null,
          strategies: const [
            SaveQuitPlanStrategyInput(
              triggerId: 'stress',
              action: 'Keluar dari meja dan minum air',
            ),
          ],
        ),
      );

      expect(edited.status, QuitPlanStatus.active);
      expect(edited.quitDate, DateTime(2026, 8, 13));
      expect(edited.supportPerson, isNull);
      expect(edited.strategies, hasLength(1));
      expect(edited.strategies.single.trigger?.id, 'stress');
    },
  );

  test('survives an app restart', () async {
    final directory = await Directory.systemTemp.createTemp(
      'serenity-plan-test-',
    );
    final path = '${directory.path}/serenity.sqlite';
    addTearDown(() => directory.delete(recursive: true));
    await database.close();
    database = AppDatabase.forTesting(NativeDatabase(File(path)));
    repository = DriftQuitPlanRepository(database);
    await database
        .into(database.motivations)
        .insert(
          MotivationsCompanion.insert(
            id: 'why-family',
            content: 'Keluarga',
            category: 'Keluarga',
            createdAt: DateTime(2026, 8, 1),
          ),
        );
    await DriftSmokingLogRepository(database).watchTriggers().first;
    await repository.savePlan(
      SaveQuitPlanInput(
        quitDate: DateTime(2026, 8, 12),
        primaryMotivationId: 'why-family',
        supportPerson: null,
        strategies: const [
          SaveQuitPlanStrategyInput(
            triggerId: 'coffee',
            action: 'Air dan permen karet',
          ),
        ],
      ),
    );
    await database.close();

    database = AppDatabase.forTesting(NativeDatabase(File(path)));
    repository = DriftQuitPlanRepository(database);
    final plan = await repository.getPlan();

    expect(plan?.quitDate, DateTime(2026, 8, 12));
    expect(plan?.strategies.single.action, 'Air dan permen karet');
  });
}
