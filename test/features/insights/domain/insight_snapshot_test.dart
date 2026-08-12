import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/features/craving/domain/entities/craving_session.dart';
import 'package:serenity_app/features/insights/domain/entities/insight_snapshot.dart';
import 'package:serenity_app/features/onboarding/domain/entities/goal_type.dart';
import 'package:serenity_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:serenity_app/features/quit_plan/domain/entities/quit_plan.dart';
import 'package:serenity_app/features/smoking_log/domain/entities/smoking_log.dart';

void main() {
  final now = DateTime(2026, 8, 11, 14);

  test(
    'creates continuous local-day counts and identifies time and trigger patterns',
    () {
      final snapshot = InsightSnapshot.calculate(
        profile: _profile(),
        smokingLogs: [
          _log('a', DateTime(2026, 8, 5, 21), triggers: const [_coffee]),
          _log('b', DateTime(2026, 8, 7, 22), triggers: const [_coffee]),
          _log('c', DateTime(2026, 8, 7, 8), triggers: const [_stress]),
          _log('d', DateTime(2026, 8, 9, 21)),
          _log('future', DateTime(2026, 8, 12, 21), triggers: const [_coffee]),
        ],
        cravingSessions: const [],
        quitPlan: null,
        now: now,
        days: 7,
      );

      expect(snapshot.dailyCigarettes, hasLength(7));
      expect(snapshot.dailyCigarettes.first.day, DateTime(2026, 8, 5));
      expect(snapshot.dailyCigarettes.map((item) => item.count), [
        1,
        0,
        2,
        0,
        1,
        0,
        0,
      ]);
      expect(snapshot.timeOfDayPatterns.last.label, '21–24');
      expect(snapshot.timeOfDayPatterns.last.count, 3);
      expect(snapshot.triggerUsage.first.name, 'Kopi');
      expect(snapshot.triggerUsage.first.count, 2);
      expect(snapshot.triggerUsage.first.percentageOfLogs, 50);
    },
  );

  test(
    'derives craving outcomes and averages without medical interpretation',
    () {
      final snapshot = InsightSnapshot.calculate(
        profile: _profile(),
        smokingLogs: const [],
        cravingSessions: [
          _session('passed', 4, 2, CravingOutcome.passed),
          _session('delayed', 2, 1, CravingOutcome.delayed),
          _session('abandoned', 5, null, CravingOutcome.abandoned),
          CravingSession(
            id: 'active',
            startedAt: now,
            endedAt: null,
            initialIntensity: 5,
            finalIntensity: null,
            outcome: null,
            note: null,
          ),
        ],
        quitPlan: null,
        now: now,
        days: 7,
      );

      expect(snapshot.craving.totalCompleted, 3);
      expect(snapshot.craving.averageInitialIntensity, 11 / 3);
      expect(snapshot.craving.averageFinalIntensity, 1.5);
      expect(snapshot.craving.outcomes[CravingOutcome.passed], 1);
      expect(snapshot.craving.outcomes[CravingOutcome.delayed], 1);
      expect(snapshot.craving.outcomes[CravingOutcome.smoked], 0);
      expect(snapshot.craving.outcomes[CravingOutcome.abandoned], 1);
    },
  );

  test(
    'uses completed local days for lifetime progress and never makes avoided negative',
    () {
      final snapshot = InsightSnapshot.calculate(
        profile: _profile(),
        smokingLogs: [
          _log('day-one', DateTime(2026, 8, 9, 8)),
          _log('day-two-a', DateTime(2026, 8, 10, 8)),
          _log('day-two-b', DateTime(2026, 8, 10, 20)),
          _log('today', DateTime(2026, 8, 11, 8)),
        ],
        cravingSessions: const [],
        quitPlan: _activePlan(),
        now: now,
        days: 7,
      );

      expect(snapshot.journey.cigarettesAvoided, 3);
      expect(snapshot.journey.daysBelowBaseline, 2);
      expect(snapshot.journey.moneyNotSpent, 3000);
      expect(
        snapshot.journey.currentSmokeFreeDuration,
        const Duration(hours: 6),
      );
      expect(
        snapshot.journey.longestSmokeFreeDuration,
        const Duration(hours: 24),
      );

      final noNegative = InsightSnapshot.calculate(
        profile: _profile(),
        smokingLogs: List.generate(
          7,
          (index) => _log('many-$index', DateTime(2026, 8, 9, 8 + index)),
        ),
        cravingSessions: const [],
        quitPlan: _activePlan(),
        now: now,
        days: 7,
      );
      expect(noNegative.journey.cigarettesAvoided, 0);
    },
  );

  test(
    'keeps range-selected craving summaries inside the selected local days',
    () {
      final snapshot = InsightSnapshot.calculate(
        profile: _profile(),
        smokingLogs: const [],
        cravingSessions: [
          _sessionAt(
            'older-session',
            DateTime(2026, 7, 30, 8),
            5,
            4,
            CravingOutcome.smoked,
          ),
          _sessionAt(
            'recent-session',
            DateTime(2026, 8, 10, 8),
            2,
            1,
            CravingOutcome.passed,
          ),
        ],
        quitPlan: null,
        now: now,
        days: 7,
      );

      expect(snapshot.craving.totalCompleted, 1);
      expect(snapshot.craving.averageInitialIntensity, 2);
      expect(snapshot.craving.averageFinalIntensity, 1);
      expect(snapshot.craving.outcomes[CravingOutcome.passed], 1);
      expect(snapshot.craving.outcomes[CravingOutcome.smoked], 0);
    },
  );
}

const _coffee = TriggerTag(id: 'coffee', name: 'Kopi', isDefault: true);
const _stress = TriggerTag(id: 'stress', name: 'Stres', isDefault: true);

UserProfile _profile() => UserProfile(
  id: 'primary',
  createdAt: DateTime(2026, 8, 1),
  baselineCigarettesPerDay: 3,
  cigarettesPerPack: 10,
  packPrice: 10000,
  goalType: GoalType.quit,
  onboardingCompleted: true,
);

QuitPlan _activePlan() => QuitPlan(
  id: 'plan',
  quitDate: DateTime(2026, 8, 9),
  status: QuitPlanStatus.active,
  createdAt: DateTime(2026, 8, 1),
  updatedAt: DateTime(2026, 8, 1),
  strategies: const [],
);

SmokingLog _log(
  String id,
  DateTime smokedAt, {
  List<TriggerTag> triggers = const [],
}) => SmokingLog(
  id: id,
  smokedAt: smokedAt,
  cravingLevel: null,
  note: null,
  createdAt: smokedAt,
  triggers: triggers,
);

CravingSession _session(
  String id,
  int initial,
  int? finalIntensity,
  CravingOutcome outcome,
) => CravingSession(
  id: id,
  startedAt: DateTime(2026, 8, 10, 8),
  endedAt: DateTime(2026, 8, 10, 8, 5),
  initialIntensity: initial,
  finalIntensity: finalIntensity,
  outcome: outcome,
  note: null,
);

CravingSession _sessionAt(
  String id,
  DateTime startedAt,
  int initial,
  int? finalIntensity,
  CravingOutcome outcome,
) => CravingSession(
  id: id,
  startedAt: startedAt,
  endedAt: startedAt.add(const Duration(minutes: 5)),
  initialIntensity: initial,
  finalIntensity: finalIntensity,
  outcome: outcome,
  note: null,
);
