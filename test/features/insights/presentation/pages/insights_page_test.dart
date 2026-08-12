import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/app/theme/app_theme.dart';
import 'package:serenity_app/features/craving/domain/entities/craving_session.dart';
import 'package:serenity_app/features/craving/domain/repositories/craving_repository.dart';
import 'package:serenity_app/features/craving/presentation/controllers/craving_providers.dart';
import 'package:serenity_app/features/insights/presentation/controllers/insights_providers.dart';
import 'package:serenity_app/features/insights/presentation/pages/insights_page.dart';
import 'package:serenity_app/features/onboarding/domain/entities/goal_type.dart';
import 'package:serenity_app/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:serenity_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:serenity_app/features/onboarding/domain/repositories/profile_repository.dart';
import 'package:serenity_app/features/onboarding/presentation/controllers/onboarding_providers.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_plan.dart';
import 'package:serenity_app/features/quit_plan/domain/repositories/quit_plan_repository.dart';
import 'package:serenity_app/features/quit_plan/presentation/controllers/quit_plan_providers.dart';
import 'package:serenity_app/features/smoking_log/domain/entities/smoking_log.dart';
import 'package:serenity_app/features/smoking_log/domain/repositories/smoking_log_repository.dart';
import 'package:serenity_app/features/smoking_log/presentation/controllers/smoking_log_providers.dart';

void main() {
  testWidgets('shows learning states and supports the 30-day range', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(_ProfileRepository()),
          smokingLogRepositoryProvider.overrideWithValue(_SmokingRepository()),
          cravingRepositoryProvider.overrideWithValue(_CravingRepository()),
          quitPlanRepositoryProvider.overrideWithValue(_QuitPlanRepository()),
          insightsClockProvider.overrideWithValue(
            () => DateTime(2026, 8, 11, 14),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const InsightsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Insight'), findsOneWidget);
    expect(
      find.text('Belum cukup data untuk melihat pola jam merokokmu.'),
      findsOneWidget,
    );
    expect(find.textContaining('Belum ada pemicu'), findsOneWidget);

    await tester.tap(find.text('30 hari'));
    await tester.pumpAndSettle();
    expect(find.text('30 hari'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Cubit untuk zoom, lalu geser ke samping untuk melihat tanggal lainnya.',
      ),
      findsOneWidget,
    );
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });
}

class _ProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile?> getProfile() async => _profile;

  @override
  Future<List<PersonalMotivation>> getMotivations() async => const [];

  @override
  Future<void> saveOnboarding(OnboardingDraft draft) async {}

  @override
  Stream<UserProfile?> watchProfile() => Stream.value(_profile);
}

final _profile = UserProfile(
  id: 'primary',
  createdAt: DateTime(2026, 8, 1),
  baselineCigarettesPerDay: 5,
  goalType: GoalType.reduce,
  onboardingCompleted: true,
);

class _SmokingRepository implements SmokingLogRepository {
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
  Stream<List<TriggerTag>> watchTriggers() => Stream.value(const []);
}

class _CravingRepository implements CravingRepository {
  @override
  Future<CravingSession> finishSession(FinishCravingSessionInput input) =>
      throw UnimplementedError();

  @override
  Future<CravingSession?> getActiveSession() async => null;

  @override
  Future<CravingSession> startSession(StartCravingSessionInput input) =>
      throw UnimplementedError();

  @override
  Stream<List<CravingSession>> watchSessions() => Stream.value(const []);
}

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
