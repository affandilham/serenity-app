import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:serenity_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:serenity_app/features/onboarding/domain/repositories/profile_repository.dart';
import 'package:serenity_app/features/onboarding/presentation/controllers/onboarding_providers.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_plan.dart';
import 'package:serenity_app/features/quit_plan/domain/repositories/quit_plan_repository.dart';
import 'package:serenity_app/features/quit_plan/presentation/controllers/quit_plan_providers.dart';
import 'package:serenity_app/features/quit_plan/presentation/pages/quit_plan_editor_page.dart';
import 'package:serenity_app/features/smoking_log/domain/entities/smoking_log.dart';
import 'package:serenity_app/features/smoking_log/domain/repositories/smoking_log_repository.dart';
import 'package:serenity_app/features/smoking_log/presentation/controllers/smoking_log_providers.dart';

void main() {
  testWidgets('editor presents calm, focused Quit Plan fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quitPlanRepositoryProvider.overrideWithValue(
            _FakeQuitPlanRepository(),
          ),
          profileRepositoryProvider.overrideWithValue(_FakeProfileRepository()),
          smokingLogRepositoryProvider.overrideWithValue(
            _FakeSmokingLogRepository(),
          ),
          quitPlanClockProvider.overrideWithValue(() => DateTime(2026, 8, 11)),
        ],
        child: const MaterialApp(home: QuitPlanEditorPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rencana berhenti'), findsOneWidget);
    expect(find.text('Tanggal berhenti'), findsOneWidget);
    expect(find.text('Pemicu terbesar dan rencanamu'), findsOneWidget);
    expect(find.text('Saat craving datang'), findsOneWidget);
  });
}

class _FakeQuitPlanRepository implements QuitPlanRepository {
  @override
  Future<QuitPlan?> getPlan() async => null;

  @override
  Future<QuitPlan> savePlan(SaveQuitPlanInput input) {
    throw UnimplementedError();
  }

  @override
  Future<QuitPlan> transitionPlan({
    required String planId,
    required QuitPlanStatus status,
    required DateTime updatedAt,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<QuitPlan?> watchPlan() => Stream.value(null);
}

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<List<PersonalMotivation>> getMotivations() async => const [];

  @override
  Future<UserProfile?> getProfile() async => null;

  @override
  Future<void> saveOnboarding(OnboardingDraft draft) async {}

  @override
  Stream<UserProfile?> watchProfile() => Stream.value(null);
}

class _FakeSmokingLogRepository implements SmokingLogRepository {
  @override
  Future<void> addLog(CreateSmokingLogInput input) async {}

  @override
  Future<List<DailySmokingCount>> dailyCounts({
    required DateTime from,
    required DateTime to,
  }) async => const [];

  @override
  Future<Map<int, int>> hourlyCounts({
    required DateTime from,
    required DateTime to,
  }) async => const {};

  @override
  Future<List<TriggerUsage>> triggerUsage({
    required DateTime from,
    required DateTime to,
  }) async => const [];

  @override
  Stream<int> watchCountForDay(DateTime day) => Stream.value(0);

  @override
  Stream<List<SmokingLog>> watchLogs({DateTime? from, DateTime? to}) =>
      Stream.value(const []);

  @override
  Stream<List<TriggerTag>> watchTriggers() => Stream.value(const [
    TriggerTag(id: 'coffee', name: 'Kopi', isDefault: true),
  ]);
}
