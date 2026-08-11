import '../entities/onboarding_draft.dart';
import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  Stream<UserProfile?> watchProfile();

  Future<UserProfile?> getProfile();

  Future<List<PersonalMotivation>> getMotivations();

  Future<void> saveOnboarding(OnboardingDraft draft);
}
