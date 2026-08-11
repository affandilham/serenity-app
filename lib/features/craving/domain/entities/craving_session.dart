enum CravingOutcome { passed, delayed, smoked, abandoned }

class CravingSession {
  const CravingSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.initialIntensity,
    required this.finalIntensity,
    required this.outcome,
    required this.note,
  }) : assert(initialIntensity >= 1 && initialIntensity <= 5),
       assert(
         finalIntensity == null || (finalIntensity >= 1 && finalIntensity <= 5),
       );

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int initialIntensity;
  final int? finalIntensity;
  final CravingOutcome? outcome;
  final String? note;

  bool get isActive => endedAt == null;
}

class StartCravingSessionInput {
  const StartCravingSessionInput({
    required this.id,
    required this.startedAt,
    required this.initialIntensity,
    this.note,
  }) : assert(initialIntensity >= 1 && initialIntensity <= 5);

  final String id;
  final DateTime startedAt;
  final int initialIntensity;
  final String? note;
}

class FinishCravingSessionInput {
  const FinishCravingSessionInput({
    required this.sessionId,
    required this.endedAt,
    required this.outcome,
    this.finalIntensity,
  }) : assert(
         finalIntensity == null || (finalIntensity >= 1 && finalIntensity <= 5),
       ),
       assert(outcome == CravingOutcome.abandoned || finalIntensity != null);

  final String sessionId;
  final DateTime endedAt;
  final CravingOutcome outcome;
  final int? finalIntensity;
}
