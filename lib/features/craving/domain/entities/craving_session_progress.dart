import 'craving_session.dart';

class CravingSosStep {
  const CravingSosStep({required this.title, required this.guidance});

  final String title;
  final String guidance;
}

class CravingSessionProgress {
  const CravingSessionProgress({
    required this.elapsed,
    required this.remaining,
    required this.currentStepIndex,
  });

  static const duration = Duration(minutes: 5);

  static const steps = <CravingSosStep>[
    CravingSosStep(
      title: 'Bernapas',
      guidance: 'Tarik biasa. Keluarkan sedikit lebih lambat.',
    ),
    CravingSosStep(
      title: 'Minum',
      guidance:
          'Minum air perlahan. Beri tangan dan mulut sesuatu untuk dilakukan.',
    ),
    CravingSosStep(
      title: 'Bergerak',
      guidance: 'Berdiri dan berjalan sebentar. Ubah tempatmu kalau bisa.',
    ),
    CravingSosStep(
      title: 'Alihkan',
      guidance:
          'Pilih satu hal kecil: keluar ruangan, chat seseorang, atau kunyah permen.',
    ),
    CravingSosStep(
      title: 'Cek lagi',
      guidance:
          'Perhatikan keinginanmu sekarang, tanpa perlu menghakimi diri sendiri.',
    ),
  ];

  final Duration elapsed;
  final Duration remaining;
  final int currentStepIndex;

  bool get isComplete => remaining == Duration.zero;

  CravingSosStep get currentStep => steps[currentStepIndex];

  factory CravingSessionProgress.at({
    required CravingSession session,
    required DateTime now,
  }) {
    final rawElapsed = now.difference(session.startedAt);
    final elapsed = rawElapsed.isNegative
        ? Duration.zero
        : rawElapsed > duration
        ? duration
        : rawElapsed;
    final stepDuration = Duration(
      milliseconds: duration.inMilliseconds ~/ steps.length,
    );
    final index = elapsed.inMilliseconds ~/ stepDuration.inMilliseconds;
    return CravingSessionProgress(
      elapsed: elapsed,
      remaining: duration - elapsed,
      currentStepIndex: index.clamp(0, steps.length - 1),
    );
  }
}
