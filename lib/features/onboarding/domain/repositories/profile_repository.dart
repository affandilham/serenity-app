import '../entities/onboarding_draft.dart';
import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  Stream<UserProfile?> watchProfile();

  Future<UserProfile?> getProfile();

  Future<List<PersonalMotivation>> getMotivations();

  Future<void> saveOnboarding(OnboardingDraft draft);

  Future<void> updatePattern({
    required int baselineCigarettesPerDay,
    required int? cigarettesPerPack,
    required int? packPrice,
  });
}
