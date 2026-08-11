import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/craving_session.dart';
import '../../domain/repositories/craving_repository.dart';

class DriftCravingRepository implements CravingRepository {
  DriftCravingRepository(this._database);

  final db.AppDatabase _database;

  @override
  Future<CravingSession> startSession(StartCravingSessionInput input) async {
    final activeSession = await getActiveSession();
    if (activeSession != null) {
      throw StateError('A craving session is already active.');
    }

    await _database
        .into(_database.cravingSessions)
        .insert(
          db.CravingSessionsCompanion.insert(
            id: input.id,
            startedAt: input.startedAt,
            initialIntensity: input.initialIntensity,
            note: Value(_cleanNote(input.note)),
          ),
        );
    return _sessionFromRow(
      await (_database.select(
        _database.cravingSessions,
      )..where((table) => table.id.equals(input.id))).getSingle(),
    );
  }

  @override
  Future<CravingSession> finishSession(FinishCravingSessionInput input) async {
    final updated =
        await (_database.update(
          _database.cravingSessions,
        )..where((table) => table.id.equals(input.sessionId))).write(
          db.CravingSessionsCompanion(
            endedAt: Value(input.endedAt),
            finalIntensity: Value(input.finalIntensity),
            outcome: Value(input.outcome.name),
          ),
        );
    if (updated != 1) {
      throw StateError('The craving session could not be found.');
    }
    return _sessionFromRow(
      await (_database.select(
        _database.cravingSessions,
      )..where((table) => table.id.equals(input.sessionId))).getSingle(),
    );
  }

  @override
  Future<CravingSession?> getActiveSession() async {
    final query = _database.select(_database.cravingSessions)
      ..where((table) => table.endedAt.isNull())
      ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]);
    final row = await query.getSingleOrNull();
    return row == null ? null : _sessionFromRow(row);
  }

  @override
  Stream<List<CravingSession>> watchSessions() {
    final query = _database.select(_database.cravingSessions)
      ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]);
    return query.watch().map(
      (rows) => rows.map(_sessionFromRow).toList(growable: false),
    );
  }

  CravingSession _sessionFromRow(db.CravingSession row) => CravingSession(
    id: row.id,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
    initialIntensity: row.initialIntensity,
    finalIntensity: row.finalIntensity,
    outcome: row.outcome == null
        ? null
        : CravingOutcome.values.byName(row.outcome!),
    note: row.note,
  );

  String? _cleanNote(String? note) {
    final cleaned = note?.trim();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }
}
