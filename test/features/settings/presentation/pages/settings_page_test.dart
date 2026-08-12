import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/app/theme/app_theme.dart';
import 'package:serenity_app/features/onboarding/domain/entities/goal_type.dart';
import 'package:serenity_app/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:serenity_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:serenity_app/features/onboarding/domain/repositories/profile_repository.dart';
import 'package:serenity_app/features/onboarding/presentation/controllers/onboarding_providers.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_plan.dart';
import 'package:serenity_app/features/quit_plan/domain/repositories/quit_plan_repository.dart';
import 'package:serenity_app/features/quit_plan/presentation/controllers/quit_plan_providers.dart';
import 'package:serenity_app/features/settings/domain/entities/settings_preferences.dart';
import 'package:serenity_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:serenity_app/features/settings/presentation/controllers/settings_providers.dart';
import 'package:serenity_app/features/settings/presentation/pages/settings_page.dart';

void main() {
  testWidgets('delete all data requires an explicit confirmation', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(_SettingsRepository()),
          profileRepositoryProvider.overrideWithValue(_ProfileRepository()),
          quitPlanRepositoryProvider.overrideWithValue(_QuitPlanRepository()),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const SettingsPage()),
      ),
    );
    await tester.pumpAndSettle();

    final deleteTile = find.widgetWithText(ListTile, 'Hapus semua data');
    await tester.scrollUntilVisible(
      deleteTile,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -140));
    await tester.pumpAndSettle();
    await tester.tap(deleteTile);
    await tester.pumpAndSettle();

    expect(find.text('Hapus semua data Serenity?'), findsOneWidget);
    expect(find.text('Hapus semua'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus semua data Serenity?'), findsNothing);
  });
}

class _SettingsRepository implements SettingsRepository {
  SettingsPreferences value = SettingsPreferences.defaults;

  @override
  Future<SettingsPreferences> getPreferences() async => value;

  @override
  Future<void> savePreferences(SettingsPreferences preferences) async {
    value = preferences;
  }

  @override
  Stream<SettingsPreferences> watchPreferences() => Stream.value(value);
}

class _ProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile?> getProfile() async => _profile;

  @override
  Future<List<PersonalMotivation>> getMotivations() async => const [];

  @override
  Future<void> saveOnboarding(OnboardingDraft draft) async {}

  @override
  Future<void> updatePattern({
    required int baselineCigarettesPerDay,
    required int? cigarettesPerPack,
    required int? packPrice,
  }) async {}

  @override
  Stream<UserProfile?> watchProfile() => Stream.value(_profile);
}

final _profile = UserProfile(
  id: 'primary',
  createdAt: DateTime(2026, 8, 12),
  baselineCigarettesPerDay: 6,
  goalType: GoalType.reduce,
  onboardingCompleted: true,
);

class _QuitPlanRepository implements QuitPlanRepository {
  @override
  Future<QuitPlan?> getPlan() async => null;

  @override
  Future<QuitPlan> savePlan(SaveQuitPlanInput input) =>
      throw UnimplementedError();

  @override
  Future<QuitPlan> transitionPlan({
    required String planId,
    required QuitPlanStatus status,
    required DateTime updatedAt,
  }) => throw UnimplementedError();

  @override
  Stream<QuitPlan?> watchPlan() => Stream.value(null);
}
