import 'dart:convert';

import '../../../../core/database/app_database.dart';

class SerenityExportService {
  SerenityExportService(this._database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _database;
  final DateTime Function() _clock;

  Future<String> buildJson() async {
    final profile = await _database
        .select(_database.userProfiles)
        .getSingleOrNull();
    final motivations = await _database.select(_database.motivations).get();
    final triggers = await _database.select(_database.triggers).get();
    final logs = await _database.select(_database.smokingLogs).get();
    final logTriggers = await _database
        .select(_database.smokingLogTriggers)
        .get();
    final cravings = await _database.select(_database.cravingSessions).get();
    final plans = await _database.select(_database.quitPlans).get();
    final strategies = await _database
        .select(_database.quitPlanStrategies)
        .get();
    final metadata = await _database.select(_database.appMetadata).get();
    final triggerIdsByLog = <String, List<String>>{};
    for (final item in logTriggers) {
      triggerIdsByLog
          .putIfAbsent(item.smokingLogId, () => [])
          .add(item.triggerId);
    }
    final strategiesByPlan = <String, List<QuitPlanStrategy>>{};
    for (final item in strategies) {
      strategiesByPlan.putIfAbsent(item.quitPlanId, () => []).add(item);
    }
    return const JsonEncoder.withIndent('  ').convert({
      'exportVersion': 1,
      'app': 'Serenity',
      'exportedAt': _clock().toUtc().toIso8601String(),
      'profile': profile == null ? null : _profile(profile),
      'motivations': motivations.map(_motivation).toList(),
      'triggers': triggers.map(_trigger).toList(),
      'smokingLogs': logs
          .map(
            (item) => _smokingLog(item, triggerIdsByLog[item.id] ?? const []),
          )
          .toList(),
      'cravingSessions': cravings.map(_craving).toList(),
      'quitPlans': plans
          .map((item) => _quitPlan(item, strategiesByPlan[item.id] ?? const []))
          .toList(),
      'settings': {
        for (final item in metadata.where(
          (item) => item.key.startsWith('settings.'),
        ))
          item.key.substring('settings.'.length): item.value,
      },
    });
  }

  Map<String, Object?> _profile(UserProfile row) => {
    'id': row.id,
    'createdAt': _date(row.createdAt),
    'baselineCigarettesPerDay': row.baselineCigarettesPerDay,
    'cigarettesPerPack': row.cigarettesPerPack,
    'packPrice': row.packPrice,
    'firstCigaretteAfterWakingMinutes': row.firstCigaretteAfterWakingMinutes,
    'goalType': row.goalType,
    'onboardingCompleted': row.onboardingCompleted,
  };

  Map<String, Object?> _motivation(Motivation row) => {
    'id': row.id,
    'text': row.content,
    'category': row.category,
    'showDuringCraving': row.showDuringCraving,
    'sortOrder': row.sortOrder,
    'createdAt': _date(row.createdAt),
  };

  Map<String, Object?> _trigger(Trigger row) => {
    'id': row.id,
    'name': row.name,
    'isDefault': row.isDefault,
    'createdAt': _date(row.createdAt),
  };

  Map<String, Object?> _smokingLog(SmokingLog row, List<String> triggerIds) => {
    'id': row.id,
    'smokedAt': _date(row.smokedAt),
    'cravingLevel': row.cravingLevel,
    'note': row.note,
    'createdAt': _date(row.createdAt),
    'triggerIds': triggerIds,
  };

  Map<String, Object?> _craving(CravingSession row) => {
    'id': row.id,
    'startedAt': _date(row.startedAt),
    'endedAt': row.endedAt == null ? null : _date(row.endedAt!),
    'initialIntensity': row.initialIntensity,
    'finalIntensity': row.finalIntensity,
    'outcome': row.outcome,
    'note': row.note,
  };

  Map<String, Object?> _quitPlan(
    QuitPlan row,
    List<QuitPlanStrategy> strategies,
  ) => {
    'id': row.id,
    'quitDate': _date(row.quitDate),
    'primaryMotivationId': row.primaryMotivationId,
    'supportPerson': row.supportPerson,
    'status': row.status,
    'createdAt': _date(row.createdAt),
    'updatedAt': _date(row.updatedAt),
    'strategies': strategies
        .map(
          (item) => {
            'id': item.id,
            'triggerId': item.triggerId,
            'action': item.action,
            'createdAt': _date(item.createdAt),
          },
        )
        .toList(),
  };

  String _date(DateTime value) => value.toUtc().toIso8601String();
}
