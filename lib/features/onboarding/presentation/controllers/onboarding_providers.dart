import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repositories/drift_profile_repository.dart';
import '../../domain/entities/goal_type.dart';
import '../../domain/entities/onboarding_draft.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return DriftProfileRepository(ref.watch(appDatabaseProvider));
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(profileRepositoryProvider).watchProfile();
});

final onboardingDraftProvider =
    NotifierProvider<OnboardingDraftNotifier, OnboardingDraft>(
      OnboardingDraftNotifier.new,
    );

class OnboardingDraftNotifier extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  void updatePattern({
    required int? baselineCigarettesPerDay,
    required int? cigarettesPerPack,
    required int? packPrice,
    required int? firstCigaretteAfterWakingMinutes,
  }) {
    state = OnboardingDraft(
      baselineCigarettesPerDay: baselineCigarettesPerDay,
      cigarettesPerPack: cigarettesPerPack,
      packPrice: packPrice,
      firstCigaretteAfterWakingMinutes: firstCigaretteAfterWakingMinutes,
      goalType: state.goalType,
      motivationCategory: state.motivationCategory,
      motivationText: state.motivationText,
    );
  }

  void selectGoal(GoalType goalType) {
    state = OnboardingDraft(
      baselineCigarettesPerDay: state.baselineCigarettesPerDay,
      cigarettesPerPack: state.cigarettesPerPack,
      packPrice: state.packPrice,
      firstCigaretteAfterWakingMinutes: state.firstCigaretteAfterWakingMinutes,
      goalType: goalType,
      motivationCategory: state.motivationCategory,
      motivationText: state.motivationText,
    );
  }

  void updateMotivation({required String? category, required String text}) {
    state = OnboardingDraft(
      baselineCigarettesPerDay: state.baselineCigarettesPerDay,
      cigarettesPerPack: state.cigarettesPerPack,
      packPrice: state.packPrice,
      firstCigaretteAfterWakingMinutes: state.firstCigaretteAfterWakingMinutes,
      goalType: state.goalType,
      motivationCategory: category,
      motivationText: text,
    );
  }
}

final onboardingSaveProvider =
    AsyncNotifierProvider<OnboardingSaveNotifier, void>(
      OnboardingSaveNotifier.new,
    );

class OnboardingSaveNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> save() async {
    final draft = ref.read(onboardingDraftProvider);
    if (!draft.canFinish) {
      throw StateError('Onboarding details are incomplete.');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).saveOnboarding(draft),
    );
  }
}
