import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/features/onboarding/data/repositories/drift_profile_repository.dart';
import 'package:serenity_app/features/onboarding/domain/entities/goal_type.dart';
import 'package:serenity_app/features/onboarding/domain/entities/onboarding_draft.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test(
    'persists onboarding profile and optional personal motivation',
    () async {
      final repository = DriftProfileRepository(
        database,
        clock: () => DateTime.utc(2026, 8, 11, 9),
      );

      await repository.saveOnboarding(
        const OnboardingDraft(
          baselineCigarettesPerDay: 12,
          cigarettesPerPack: 16,
          packPrice: 30000,
          firstCigaretteAfterWakingMinutes: 30,
          goalType: GoalType.reduce,
          motivationCategory: 'Keluarga',
          motivationText:
              'Aku ingin punya lebih banyak waktu bersama keluarga.',
        ),
      );

      final profile = await repository.getProfile();
      final motivations = await repository.getMotivations();

      expect(profile, isNotNull);
      expect(profile!.baselineCigarettesPerDay, 12);
      expect(profile.cigarettesPerPack, 16);
      expect(profile.packPrice, 30000);
      expect(profile.firstCigaretteAfterWakingMinutes, 30);
      expect(profile.goalType, GoalType.reduce);
      expect(profile.onboardingCompleted, isTrue);
      expect(motivations, hasLength(1));
      expect(motivations.single.category, 'Keluarga');
      expect(
        motivations.single.text,
        'Aku ingin punya lebih banyak waktu bersama keluarga.',
      );
    },
  );
}
