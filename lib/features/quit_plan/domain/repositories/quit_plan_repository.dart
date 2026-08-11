import '../entities/quit_plan.dart';

abstract interface class QuitPlanRepository {
  Stream<QuitPlan?> watchPlan();

  Future<QuitPlan?> getPlan();

  Future<QuitPlan> savePlan(SaveQuitPlanInput input);

  Future<QuitPlan> transitionPlan({
    required String planId,
    required QuitPlanStatus status,
    required DateTime updatedAt,
  });
}
