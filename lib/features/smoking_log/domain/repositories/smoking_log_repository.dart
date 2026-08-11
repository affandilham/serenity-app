import '../entities/smoking_log.dart';

abstract interface class SmokingLogRepository {
  Stream<List<SmokingLog>> watchLogs({DateTime? from, DateTime? to});

  Stream<int> watchCountForDay(DateTime day);

  Stream<List<TriggerTag>> watchTriggers();

  Future<void> addLog(CreateSmokingLogInput input);

  Future<List<DailySmokingCount>> dailyCounts({
    required DateTime from,
    required DateTime to,
  });

  Future<Map<int, int>> hourlyCounts({
    required DateTime from,
    required DateTime to,
  });

  Future<List<TriggerUsage>> triggerUsage({
    required DateTime from,
    required DateTime to,
  });
}
