import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/features/onboarding/domain/entities/goal_type.dart';
import 'package:serenity_app/features/onboarding/domain/entities/onboarding_draft.dart';

void main() {
  test('requires a positive daily baseline and goal before finishing', () {
    expect(const OnboardingDraft().canFinish, isFalse);
    expect(
      const OnboardingDraft(
        baselineCigarettesPerDay: 0,
        goalType: GoalType.quit,
      ).canFinish,
      isFalse,
    );
    expect(
      const OnboardingDraft(
        baselineCigarettesPerDay: 12,
        goalType: GoalType.reduce,
      ).canFinish,
      isTrue,
    );
  });

  test('serializes every goal type predictably', () {
    for (final goal in GoalType.values) {
      expect(GoalType.fromStorage(goal.storageValue), goal);
    }
  });
}
