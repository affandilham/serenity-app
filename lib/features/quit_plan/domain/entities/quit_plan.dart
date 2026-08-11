import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../smoking_log/domain/entities/smoking_log.dart';

enum QuitPlanStatus { draft, active, paused, completed }

class QuitPlan {
  const QuitPlan({
    required this.id,
    required this.quitDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.strategies,
    this.primaryMotivation,
    this.supportPerson,
  });

  final String id;
  final DateTime quitDate;
  final QuitPlanStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PersonalMotivation? primaryMotivation;
  final String? supportPerson;
  final List<QuitPlanStrategy> strategies;
}

class QuitPlanStrategy {
  const QuitPlanStrategy({
    required this.id,
    required this.action,
    required this.createdAt,
    this.trigger,
  });

  final String id;
  final TriggerTag? trigger;
  final String action;
  final DateTime createdAt;

  bool get isCravingAction => trigger == null;
}

class SaveQuitPlanInput {
  const SaveQuitPlanInput({
    required this.quitDate,
    required this.primaryMotivationId,
    required this.supportPerson,
    required this.strategies,
    this.id,
  });

  final String? id;
  final DateTime quitDate;
  final String? primaryMotivationId;
  final String? supportPerson;
  final List<SaveQuitPlanStrategyInput> strategies;
}

class SaveQuitPlanStrategyInput {
  const SaveQuitPlanStrategyInput({required this.action, this.triggerId});

  final String? triggerId;
  final String action;
}
