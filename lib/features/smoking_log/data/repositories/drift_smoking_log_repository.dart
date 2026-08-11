import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/time/local_day.dart';
import '../../domain/entities/smoking_log.dart';
import '../../domain/repositories/smoking_log_repository.dart';

class DriftSmokingLogRepository implements SmokingLogRepository {
  DriftSmokingLogRepository(this._database);

  static const _defaultTriggers = <({String id, String name})>[
    (id: 'coffee', name: 'Kopi'),
    (id: 'after-meal', name: 'Setelah makan'),
    (id: 'stress', name: 'Stres'),
    (id: 'socializing', name: 'Nongkrong'),
    (id: 'boredom', name: 'Bosan'),
    (id: 'alcohol', name: 'Alkohol'),
    (id: 'other', name: 'Lainnya'),
  ];

  final db.AppDatabase _database;

  @override
  Future<void> addLog(CreateSmokingLogInput input) async {
    await _ensureDefaultTriggers();
    await _validateTriggerIds(input.triggerIds);

    await _database.transaction(() async {
      await _database
          .into(_database.smokingLogs)
          .insert(
            db.SmokingLogsCompanion.insert(
              id: input.id,
              smokedAt: input.smokedAt,
              cravingLevel: Value(input.cravingLevel),
              note: Value(_cleanNote(input.note)),
              createdAt: input.createdAt,
            ),
          );
      if (input.triggerIds.isNotEmpty) {
        await _database.batch((batch) {
          batch.insertAll(
            _database.smokingLogTriggers,
            input.triggerIds
                .map(
                  (triggerId) => db.SmokingLogTriggersCompanion.insert(
                    smokingLogId: input.id,
                    triggerId: triggerId,
                  ),
                )
                .toList(),
          );
        });
      }
    });
  }

  @override
  Future<List<DailySmokingCount>> dailyCounts({
    required DateTime from,
    required DateTime to,
  }) async {
    final logs = await _getLogs(from: from, to: to);
    final counts = <DateTime, int>{};
    for (final log in logs) {
      final day = startOfLocalDay(log.smokedAt);
      counts.update(day, (count) => count + 1, ifAbsent: () => 1);
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries
        .map((entry) => DailySmokingCount(day: entry.key, count: entry.value))
        .toList();
  }

  @override
  Future<Map<int, int>> hourlyCounts({
    required DateTime from,
    required DateTime to,
  }) async {
    final logs = await _getLogs(from: from, to: to);
    final counts = <int, int>{};
    for (final log in logs) {
      final hour = log.smokedAt.toLocal().hour;
      counts.update(hour, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  @override
  Future<List<TriggerUsage>> triggerUsage({
    required DateTime from,
    required DateTime to,
  }) async {
    final logs = await _getLogs(from: from, to: to);
    final usage = <String, ({TriggerTag trigger, int count})>{};
    for (final log in logs) {
      for (final trigger in log.triggers) {
        final existing = usage[trigger.id];
        usage[trigger.id] = (
          trigger: trigger,
          count: (existing?.count ?? 0) + 1,
        );
      }
    }
    final result =
        usage.values
            .map(
              (value) =>
                  TriggerUsage(trigger: value.trigger, count: value.count),
            )
            .toList()
          ..sort((a, b) {
            final byCount = b.count.compareTo(a.count);
            return byCount != 0
                ? byCount
                : a.trigger.name.compareTo(b.trigger.name);
          });
    return result;
  }

  @override
  Stream<int> watchCountForDay(DateTime day) {
    final from = startOfLocalDay(day);
    final to = startOfNextLocalDay(day);
    final query = _database.select(_database.smokingLogs)
      ..where((table) => table.smokedAt.isBiggerOrEqualValue(from))
      ..where((table) => table.smokedAt.isSmallerThanValue(to));
    return query.watch().map((logs) => logs.length);
  }

  @override
  Stream<List<SmokingLog>> watchLogs({DateTime? from, DateTime? to}) async* {
    await _ensureDefaultTriggers();
    final query = _logQuery(from: from, to: to);
    await for (final rows in query.watch()) {
      yield await Future.wait(rows.map(_logFromRow));
    }
  }

  @override
  Stream<List<TriggerTag>> watchTriggers() async* {
    await _ensureDefaultTriggers();
    final query = _database.select(_database.triggers)
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);
    yield* query.watch().map((rows) => rows.map(_triggerFromRow).toList());
  }

  Future<List<SmokingLog>> _getLogs({DateTime? from, DateTime? to}) async {
    final rows = await _logQuery(from: from, to: to).get();
    return Future.wait(rows.map(_logFromRow));
  }

  SimpleSelectStatement<db.SmokingLogs, db.SmokingLog> _logQuery({
    DateTime? from,
    DateTime? to,
  }) {
    final query = _database.select(_database.smokingLogs)
      ..orderBy([(table) => OrderingTerm.desc(table.smokedAt)]);
    if (from != null) {
      query.where((table) => table.smokedAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((table) => table.smokedAt.isSmallerThanValue(to));
    }
    return query;
  }

  Future<SmokingLog> _logFromRow(db.SmokingLog row) async {
    final triggers = await _triggersForLog(row.id);
    return SmokingLog(
      id: row.id,
      smokedAt: row.smokedAt,
      cravingLevel: row.cravingLevel,
      note: row.note,
      createdAt: row.createdAt,
      triggers: triggers,
    );
  }

  Future<List<TriggerTag>> _triggersForLog(String logId) async {
    final mappings = await (_database.select(
      _database.smokingLogTriggers,
    )..where((table) => table.smokingLogId.equals(logId))).get();
    if (mappings.isEmpty) {
      return const [];
    }
    final triggerIds = mappings.map((mapping) => mapping.triggerId).toList();
    final triggers = await (_database.select(
      _database.triggers,
    )..where((table) => table.id.isIn(triggerIds))).get();
    final triggerById = {for (final trigger in triggers) trigger.id: trigger};
    return triggerIds
        .map((id) => triggerById[id])
        .whereType<db.Trigger>()
        .map(_triggerFromRow)
        .toList();
  }

  Future<void> _ensureDefaultTriggers() async {
    final existing = await _database.select(_database.triggers).get();
    final existingIds = existing.map((trigger) => trigger.id).toSet();
    final missing = _defaultTriggers
        .where((trigger) => !existingIds.contains(trigger.id))
        .toList();
    if (missing.isEmpty) {
      return;
    }
    final now = DateTime.now();
    await _database.batch((batch) {
      batch.insertAll(
        _database.triggers,
        missing
            .map(
              (trigger) => db.TriggersCompanion.insert(
                id: trigger.id,
                name: trigger.name,
                isDefault: const Value(true),
                createdAt: now,
              ),
            )
            .toList(),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> _validateTriggerIds(Set<String> triggerIds) async {
    if (triggerIds.isEmpty) {
      return;
    }
    final found = await (_database.select(
      _database.triggers,
    )..where((table) => table.id.isIn(triggerIds))).get();
    if (found.length != triggerIds.length) {
      throw ArgumentError.value(
        triggerIds,
        'triggerIds',
        'Every trigger must exist before it can be associated with a log.',
      );
    }
  }

  TriggerTag _triggerFromRow(db.Trigger row) =>
      TriggerTag(id: row.id, name: row.name, isDefault: row.isDefault);

  String? _cleanNote(String? note) {
    final cleaned = note?.trim();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }
}
