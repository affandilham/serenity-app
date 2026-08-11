import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../smoking_log/domain/entities/smoking_log.dart';
import '../../domain/entities/quit_plan.dart';
import '../../domain/entities/quit_progress.dart';
import '../../domain/repositories/quit_plan_repository.dart';

class DriftQuitPlanRepository implements QuitPlanRepository {
  DriftQuitPlanRepository(this._database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final db.AppDatabase _database;
  final DateTime Function() _clock;

  @override
  Future<QuitPlan?> getPlan() async {
    final row = await _latestPlanRow();
    return row == null ? null : _planFromRow(row);
  }

  @override
  Future<QuitPlan> savePlan(SaveQuitPlanInput input) async {
    _validateStrategies(input.strategies);
    await _validateRelations(input);
    final now = _clock();
    final existing = input.id == null
        ? null
        : await (_database.select(
            _database.quitPlans,
          )..where((table) => table.id.equals(input.id!))).getSingleOrNull();
    final planId =
        existing?.id ?? input.id ?? 'quit-plan-${now.microsecondsSinceEpoch}';

    await _database.transaction(() async {
      if (existing == null) {
        await _database
            .into(_database.quitPlans)
            .insert(
              db.QuitPlansCompanion.insert(
                id: planId,
                quitDate: input.quitDate,
                primaryMotivationId: Value(input.primaryMotivationId),
                supportPerson: Value(_cleanText(input.supportPerson)),
                status: QuitPlanStatus.draft.name,
                createdAt: now,
                updatedAt: now,
              ),
            );
      } else {
        await (_database.update(
          _database.quitPlans,
        )..where((table) => table.id.equals(planId))).write(
          db.QuitPlansCompanion(
            quitDate: Value(input.quitDate),
            primaryMotivationId: Value(input.primaryMotivationId),
            supportPerson: Value(_cleanText(input.supportPerson)),
            updatedAt: Value(now),
          ),
        );
        await (_database.delete(
          _database.quitPlanStrategies,
        )..where((table) => table.quitPlanId.equals(planId))).go();
      }
      if (input.strategies.isNotEmpty) {
        await _database.batch((batch) {
          batch.insertAll(_database.quitPlanStrategies, [
            for (var index = 0; index < input.strategies.length; index++)
              db.QuitPlanStrategiesCompanion.insert(
                id: '$planId-strategy-$index-${now.microsecondsSinceEpoch}',
                quitPlanId: planId,
                triggerId: Value(input.strategies[index].triggerId),
                action: input.strategies[index].action.trim(),
                createdAt: now,
              ),
          ]);
        });
      }
    });
    return (await getPlan())!;
  }

  @override
  Future<QuitPlan> transitionPlan({
    required String planId,
    required QuitPlanStatus status,
    required DateTime updatedAt,
  }) async {
    final row = await (_database.select(
      _database.quitPlans,
    )..where((table) => table.id.equals(planId))).getSingleOrNull();
    if (row == null) {
      throw StateError('The quit plan could not be found.');
    }
    final current = QuitPlanStatus.values.byName(row.status);
    if (!canTransitionQuitPlan(from: current, to: status)) {
      throw StateError(
        'The transition from $current to $status is not allowed.',
      );
    }
    await (_database.update(
      _database.quitPlans,
    )..where((table) => table.id.equals(planId))).write(
      db.QuitPlansCompanion(
        status: Value(status.name),
        updatedAt: Value(updatedAt),
      ),
    );
    return (await getPlan())!;
  }

  @override
  Stream<QuitPlan?> watchPlan() {
    return _planRows().watch().asyncMap(
      (rows) async => rows.isEmpty ? null : _planFromRow(rows.first),
    );
  }

  SimpleSelectStatement<db.QuitPlans, db.QuitPlan> _planRows() {
    return _database.select(_database.quitPlans)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)])
      ..limit(1);
  }

  Future<db.QuitPlan?> _latestPlanRow() => _planRows().getSingleOrNull();

  Future<QuitPlan> _planFromRow(db.QuitPlan row) async {
    final motivation = row.primaryMotivationId == null
        ? null
        : await (_database.select(_database.motivations)
                ..where((table) => table.id.equals(row.primaryMotivationId!)))
              .getSingleOrNull();
    final strategies =
        await (_database.select(_database.quitPlanStrategies)
              ..where((table) => table.quitPlanId.equals(row.id))
              ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
            .get();
    final triggerIds = strategies
        .map((strategy) => strategy.triggerId)
        .whereType<String>()
        .toList();
    final triggers = triggerIds.isEmpty
        ? const <db.Trigger>[]
        : await (_database.select(
            _database.triggers,
          )..where((table) => table.id.isIn(triggerIds))).get();
    final triggerById = {for (final trigger in triggers) trigger.id: trigger};
    return QuitPlan(
      id: row.id,
      quitDate: row.quitDate,
      status: QuitPlanStatus.values.byName(row.status),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      primaryMotivation: motivation == null
          ? null
          : _motivationFromRow(motivation),
      supportPerson: row.supportPerson,
      strategies: strategies
          .map(
            (strategy) => QuitPlanStrategy(
              id: strategy.id,
              action: strategy.action,
              createdAt: strategy.createdAt,
              trigger: strategy.triggerId == null
                  ? null
                  : _triggerFromRow(triggerById[strategy.triggerId]),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> _validateRelations(SaveQuitPlanInput input) async {
    if (input.primaryMotivationId != null) {
      final motivation =
          await (_database.select(_database.motivations)
                ..where((table) => table.id.equals(input.primaryMotivationId!)))
              .getSingleOrNull();
      if (motivation == null) {
        throw ArgumentError.value(
          input.primaryMotivationId,
          'primaryMotivationId',
          'The selected motivation must exist.',
        );
      }
    }
    final triggerIds = input.strategies
        .map((strategy) => strategy.triggerId)
        .whereType<String>()
        .toSet();
    if (triggerIds.isEmpty) {
      return;
    }
    final triggers = await (_database.select(
      _database.triggers,
    )..where((table) => table.id.isIn(triggerIds))).get();
    if (triggers.length != triggerIds.length) {
      throw ArgumentError('Every selected trigger must exist.');
    }
  }

  void _validateStrategies(List<SaveQuitPlanStrategyInput> strategies) {
    final triggerStrategies = strategies.where(
      (item) => item.triggerId != null,
    );
    if (triggerStrategies.length > 3) {
      throw ArgumentError(
        'A quit plan can include at most three trigger plans.',
      );
    }
    if (strategies.any((strategy) => strategy.action.trim().isEmpty)) {
      throw ArgumentError('Each planned action needs a description.');
    }
  }

  PersonalMotivation _motivationFromRow(db.Motivation row) =>
      PersonalMotivation(
        id: row.id,
        text: row.content,
        category: row.category,
        showDuringCraving: row.showDuringCraving,
        sortOrder: row.sortOrder,
        createdAt: row.createdAt,
      );

  TriggerTag? _triggerFromRow(db.Trigger? row) => row == null
      ? null
      : TriggerTag(id: row.id, name: row.name, isDefault: row.isDefault);

  String? _cleanText(String? value) {
    final cleaned = value?.trim();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }
}
