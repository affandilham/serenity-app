import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_plan.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_progress.dart';

void main() {
  test('uses local calendar quit dates and explicit lifecycle transitions', () {
    final plan = _plan();
    expect(
      isQuitDateReached(
        quitDate: plan.quitDate,
        now: DateTime(2026, 8, 10, 23, 59),
      ),
      isFalse,
    );
    expect(
      isQuitDateReached(quitDate: plan.quitDate, now: DateTime(2026, 8, 11)),
      isTrue,
    );
    expect(
      canTransitionQuitPlan(
        from: QuitPlanStatus.draft,
        to: QuitPlanStatus.active,
      ),
      isTrue,
    );
    expect(
      canTransitionQuitPlan(
        from: QuitPlanStatus.active,
        to: QuitPlanStatus.paused,
      ),
      isTrue,
    );
    expect(
      canTransitionQuitPlan(
        from: QuitPlanStatus.paused,
        to: QuitPlanStatus.active,
      ),
      isTrue,
    );
    expect(
      canTransitionQuitPlan(
        from: QuitPlanStatus.completed,
        to: QuitPlanStatus.active,
      ),
      isFalse,
    );
  });

  test('a slip restarts only the current smoke-free duration', () {
    final plan = _plan();
    final progress = QuitProgress.calculate(
      plan: plan,
      smokingEvents: [DateTime(2026, 8, 11, 2), DateTime(2026, 8, 11, 5)],
      now: DateTime(2026, 8, 11, 9),
    );

    expect(progress.lastCigaretteAt, DateTime(2026, 8, 11, 5));
    expect(progress.currentSmokeFreeDuration, const Duration(hours: 4));
    expect(progress.longestSmokeFreeDuration, const Duration(hours: 4));
    expect(
      isSlipForPlan(plan: plan, smokedAt: DateTime(2026, 8, 11, 5)),
      isTrue,
    );
    expect(
      isSlipForPlan(plan: plan, smokedAt: DateTime(2026, 8, 10, 23)),
      isFalse,
    );
  });

  test('uses the exact last-cigarette timestamp when it predates quit day', () {
    final progress = QuitProgress.calculate(
      plan: _plan(),
      smokingEvents: [DateTime(2026, 8, 10, 22)],
      now: DateTime(2026, 8, 11, 9),
    );

    expect(progress.lastCigaretteAt, DateTime(2026, 8, 10, 22));
    expect(progress.currentSmokeFreeDuration, const Duration(hours: 11));
  });
}

QuitPlan _plan() => QuitPlan(
  id: 'plan',
  quitDate: DateTime(2026, 8, 11),
  status: QuitPlanStatus.active,
  createdAt: DateTime(2026, 8, 1),
  updatedAt: DateTime(2026, 8, 1),
  strategies: const [],
);
