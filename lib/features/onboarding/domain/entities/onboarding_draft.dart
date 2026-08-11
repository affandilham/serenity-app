import 'goal_type.dart';

class OnboardingDraft {
  const OnboardingDraft({
    this.baselineCigarettesPerDay,
    this.cigarettesPerPack,
    this.packPrice,
    this.firstCigaretteAfterWakingMinutes,
    this.goalType,
    this.motivationCategory,
    this.motivationText = '',
  });

  final int? baselineCigarettesPerDay;
  final int? cigarettesPerPack;
  final int? packPrice;
  final int? firstCigaretteAfterWakingMinutes;
  final GoalType? goalType;
  final String? motivationCategory;
  final String motivationText;

  bool get canFinish =>
      baselineCigarettesPerDay != null &&
      baselineCigarettesPerDay! > 0 &&
      goalType != null;
}
