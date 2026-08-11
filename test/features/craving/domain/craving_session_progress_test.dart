import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/features/craving/domain/entities/craving_session.dart';
import 'package:serenity_app/features/craving/domain/entities/craving_session_progress.dart';

void main() {
  final startedAt = DateTime(2026, 8, 11, 10);
  final session = CravingSession(
    id: 'session-1',
    startedAt: startedAt,
    endedAt: null,
    initialIntensity: 4,
    finalIntensity: null,
    outcome: null,
    note: null,
  );

  test('derives timer progress from timestamps without timer drift', () {
    final progress = CravingSessionProgress.at(
      session: session,
      now: startedAt.add(const Duration(minutes: 2, seconds: 15)),
    );

    expect(progress.elapsed, const Duration(minutes: 2, seconds: 15));
    expect(progress.remaining, const Duration(minutes: 2, seconds: 45));
    expect(progress.currentStep.title, 'Bergerak');
    expect(progress.isComplete, isFalse);
  });

  test(
    'clamps elapsed time and reaches the check-again step at five minutes',
    () {
      final progress = CravingSessionProgress.at(
        session: session,
        now: startedAt.add(const Duration(minutes: 7)),
      );

      expect(progress.elapsed, CravingSessionProgress.duration);
      expect(progress.remaining, Duration.zero);
      expect(progress.currentStep.title, 'Cek lagi');
      expect(progress.isComplete, isTrue);
    },
  );
}
