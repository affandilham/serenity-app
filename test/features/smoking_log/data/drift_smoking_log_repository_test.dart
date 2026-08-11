import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/time/local_day.dart';
import 'package:serenity_app/features/smoking_log/data/repositories/drift_smoking_log_repository.dart';
import 'package:serenity_app/features/smoking_log/domain/entities/smoking_log.dart';

void main() {
  late AppDatabase database;
  late DriftSmokingLogRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftSmokingLogRepository(database);
  });

  tearDown(() => database.close());

  test('adds a smoking log with multiple trigger associations', () async {
    final triggers = await repository.watchTriggers().first;
    final logTime = DateTime(2026, 8, 11, 8, 12);

    await repository.addLog(
      CreateSmokingLogInput(
        id: 'log-1',
        smokedAt: logTime,
        createdAt: logTime,
        cravingLevel: 4,
        note: '  Setelah sarapan  ',
        triggerIds: {'coffee', 'after-meal'},
      ),
    );

    final logs = await repository
        .watchLogs(
          from: startOfLocalDay(logTime),
          to: startOfNextLocalDay(logTime),
        )
        .first;

    expect(logs, hasLength(1));
    expect(logs.single.cravingLevel, 4);
    expect(logs.single.note, 'Setelah sarapan');
    expect(
      logs.single.triggers.map((trigger) => trigger.id),
      unorderedEquals(['coffee', 'after-meal']),
    );
    expect(await repository.watchCountForDay(logTime).first, 1);
    expect(triggers, hasLength(7));
  });

  test(
    'uses local days, local hours, and newest-first timeline ordering',
    () async {
      final day = DateTime(2026, 8, 11);
      await _addLog(
        repository,
        id: 'yesterday',
        time: DateTime(2026, 8, 10, 23, 50),
        triggerIds: {'stress'},
      );
      await _addLog(
        repository,
        id: 'morning',
        time: DateTime(2026, 8, 11, 8, 12),
        triggerIds: {'coffee', 'after-meal'},
      );
      await _addLog(
        repository,
        id: 'evening',
        time: DateTime(2026, 8, 11, 20, 45),
        triggerIds: {'coffee'},
      );

      final todayLogs = await repository
          .watchLogs(from: startOfLocalDay(day), to: startOfNextLocalDay(day))
          .first;
      final daily = await repository.dailyCounts(
        from: DateTime(2026, 8, 10),
        to: DateTime(2026, 8, 12),
      );
      final hourly = await repository.hourlyCounts(
        from: DateTime(2026, 8, 10),
        to: DateTime(2026, 8, 12),
      );
      final triggerUsage = await repository.triggerUsage(
        from: DateTime(2026, 8, 10),
        to: DateTime(2026, 8, 12),
      );

      expect(todayLogs.map((log) => log.id), ['evening', 'morning']);
      expect(daily.map((count) => count.count), [1, 2]);
      expect(daily.map((count) => count.day), [
        DateTime(2026, 8, 10),
        DateTime(2026, 8, 11),
      ]);
      expect(hourly, containsPair(8, 1));
      expect(hourly, containsPair(20, 1));
      expect(hourly, containsPair(23, 1));
      expect(triggerUsage.first.trigger.id, 'coffee');
      expect(triggerUsage.first.count, 2);
    },
  );

  test('persists logs and trigger links after a database reload', () async {
    final directory = await Directory.systemTemp.createTemp(
      'serenity-log-test-',
    );
    final path = '${directory.path}/serenity.sqlite';
    addTearDown(() => directory.delete(recursive: true));

    await database.close();
    database = AppDatabase.forTesting(NativeDatabase(File(path)));
    repository = DriftSmokingLogRepository(database);
    final time = DateTime(2026, 8, 11, 10, 47);
    await _addLog(
      repository,
      id: 'persistent-log',
      time: time,
      triggerIds: {'coffee', 'stress'},
    );
    await database.close();

    database = AppDatabase.forTesting(NativeDatabase(File(path)));
    repository = DriftSmokingLogRepository(database);
    final logs = await repository
        .watchLogs(from: startOfLocalDay(time), to: startOfNextLocalDay(time))
        .first;

    expect(logs, hasLength(1));
    expect(logs.single.id, 'persistent-log');
    expect(
      logs.single.triggers.map((trigger) => trigger.id),
      unorderedEquals(['coffee', 'stress']),
    );
  });
}

Future<void> _addLog(
  DriftSmokingLogRepository repository, {
  required String id,
  required DateTime time,
  required Set<String> triggerIds,
}) {
  return repository.addLog(
    CreateSmokingLogInput(
      id: id,
      smokedAt: time,
      createdAt: time,
      triggerIds: triggerIds,
    ),
  );
}
