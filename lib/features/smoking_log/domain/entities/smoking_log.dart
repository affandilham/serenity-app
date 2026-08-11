class TriggerTag {
  const TriggerTag({
    required this.id,
    required this.name,
    required this.isDefault,
  });

  final String id;
  final String name;
  final bool isDefault;
}

class SmokingLog {
  const SmokingLog({
    required this.id,
    required this.smokedAt,
    required this.cravingLevel,
    required this.note,
    required this.createdAt,
    required this.triggers,
  });

  final String id;
  final DateTime smokedAt;
  final int? cravingLevel;
  final String? note;
  final DateTime createdAt;
  final List<TriggerTag> triggers;
}

class CreateSmokingLogInput {
  const CreateSmokingLogInput({
    required this.id,
    required this.smokedAt,
    required this.createdAt,
    this.cravingLevel,
    this.note,
    this.triggerIds = const {},
  }) : assert(cravingLevel == null || (cravingLevel >= 1 && cravingLevel <= 5));

  final String id;
  final DateTime smokedAt;
  final DateTime createdAt;
  final int? cravingLevel;
  final String? note;
  final Set<String> triggerIds;
}

class DailySmokingCount {
  const DailySmokingCount({required this.day, required this.count});

  final DateTime day;
  final int count;
}

class TriggerUsage {
  const TriggerUsage({required this.trigger, required this.count});

  final TriggerTag trigger;
  final int count;
}
