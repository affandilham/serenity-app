import 'goal_type.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.createdAt,
    required this.baselineCigarettesPerDay,
    required this.goalType,
    required this.onboardingCompleted,
    this.cigarettesPerPack,
    this.packPrice,
    this.firstCigaretteAfterWakingMinutes,
  });

  final String id;
  final DateTime createdAt;
  final int baselineCigarettesPerDay;
  final int? cigarettesPerPack;
  final int? packPrice;
  final int? firstCigaretteAfterWakingMinutes;
  final GoalType goalType;
  final bool onboardingCompleted;
}

class PersonalMotivation {
  const PersonalMotivation({
    required this.id,
    required this.text,
    required this.category,
    required this.createdAt,
    this.showDuringCraving = false,
    this.sortOrder = 0,
  });

  final String id;
  final String text;
  final String category;
  final bool showDuringCraving;
  final int sortOrder;
  final DateTime createdAt;
}
