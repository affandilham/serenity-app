import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../smoking_log/presentation/widgets/quick_smoking_log_sheet.dart';
import '../../domain/entities/craving_session.dart';
import '../../domain/entities/craving_session_progress.dart';
import '../controllers/craving_providers.dart';

class CravingSosPage extends ConsumerWidget {
  const CravingSosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(cravingSessionControllerProvider);
    return AppScaffold(
      child: session.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _CravingLoadError(
          onRetry: () => ref.invalidate(cravingSessionControllerProvider),
        ),
        data: (value) => value == null
            ? const _CravingStartView()
            : _ActiveCravingSession(session: value),
      ),
    );
  }
}

class _CravingLoadError extends StatelessWidget {
  const _CravingLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sesi belum bisa dimuat.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Coba lagi sebentar. Data tetap tersimpan di perangkatmu.',
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: 'Coba lagi', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _CravingStartView extends ConsumerStatefulWidget {
  const _CravingStartView();

  @override
  ConsumerState<_CravingStartView> createState() => _CravingStartViewState();
}

class _CravingStartViewState extends ConsumerState<_CravingStartView> {
  int _initialIntensity = 3;

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(cravingSessionControllerProvider);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Saya lagi ngidam',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Oke. Jangan pikirkan selamanya.\n\nKita lewati beberapa menit ini dulu.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seberapa kuat keinginannya sekarang? (opsional)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _IntensitySelector(
                      value: _initialIntensity,
                      onChanged: saveState.isLoading
                          ? null
                          : (value) =>
                                setState(() => _initialIntensity = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Mulai 5 menit',
                onPressed: saveState.isLoading ? null : _start,
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'Saya sudah merokok',
                onPressed: saveState.isLoading ? null : _openSmokingLog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _start() async {
    await ref
        .read(cravingSessionControllerProvider.notifier)
        .start(initialIntensity: _initialIntensity);
    if (!mounted || !ref.read(cravingSessionControllerProvider).hasError) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesi belum bisa dimulai. Coba lagi sebentar.'),
      ),
    );
  }

  Future<void> _openSmokingLog() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          QuickSmokingLogSheet(initialCravingLevel: _initialIntensity),
    );
  }
}

class _ActiveCravingSession extends ConsumerStatefulWidget {
  const _ActiveCravingSession({required this.session});

  final CravingSession session;

  @override
  ConsumerState<_ActiveCravingSession> createState() =>
      _ActiveCravingSessionState();
}

class _ActiveCravingSessionState extends ConsumerState<_ActiveCravingSession>
    with WidgetsBindingObserver {
  Timer? _ticker;
  late int _finalIntensity;

  @override
  void initState() {
    super.initState();
    _finalIntensity = widget.session.initialIntensity;
    WidgetsBinding.instance.addObserver(this);
    _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTicker();
      setState(() {});
    } else {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(cravingClockProvider)();
    final progress = CravingSessionProgress.at(
      session: widget.session,
      now: now,
    );
    final saveState = ref.watch(cravingSessionControllerProvider);
    final isSaving = saveState.isLoading;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ambil beberapa menit ini',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    _formatDuration(progress.remaining),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _StepIndicator(currentStepIndex: progress.currentStepIndex),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.currentStep.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      progress.currentStep.guidance,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (progress.isComplete) ...[
                Text(
                  'Seberapa kuat keinginannya sekarang?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                _IntensitySelector(
                  value: _finalIntensity,
                  onChanged: isSaving
                      ? null
                      : (value) => setState(() => _finalIntensity = value),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Sudah lewat',
                  onPressed: isSaving
                      ? null
                      : () => _finish(CravingOutcome.passed, _finalIntensity),
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Tambah 5 menit',
                  onPressed: isSaving ? null : _extend,
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Saya merokok',
                  onPressed: isSaving
                      ? null
                      : () => _finish(CravingOutcome.smoked, _finalIntensity),
                ),
              ] else ...[
                Text(
                  'Tidak perlu sempurna. Cukup tetap di sini sebentar.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                SecondaryButton(
                  label: 'Akhiri sesi dulu',
                  onPressed: isSaving
                      ? null
                      : () => _finish(CravingOutcome.abandoned, null),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _finish(CravingOutcome outcome, int? finalIntensity) async {
    await ref
        .read(cravingSessionControllerProvider.notifier)
        .finish(outcome: outcome, finalIntensity: finalIntensity);
    if (!mounted) {
      return;
    }
    if (ref.read(cravingSessionControllerProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi belum bisa disimpan. Coba lagi sebentar.'),
        ),
      );
      return;
    }
    if (outcome == CravingOutcome.smoked) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => QuickSmokingLogSheet(
          initialCravingLevel:
              finalIntensity ?? widget.session.initialIntensity,
        ),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    final message = switch (outcome) {
      CravingOutcome.passed => 'Bagus, kamu sudah memberi dirimu ruang.',
      CravingOutcome.delayed => 'Kamu sudah memberi diri beberapa menit lagi.',
      CravingOutcome.abandoned =>
        'Tercatat. Kamu bisa kembali kapan pun kamu butuh.',
      CravingOutcome.smoked => '',
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    Navigator.of(context).pop();
  }

  Future<void> _extend() async {
    await ref
        .read(cravingSessionControllerProvider.notifier)
        .extend(currentIntensity: _finalIntensity);
    if (!mounted) {
      return;
    }
    if (ref.read(cravingSessionControllerProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi belum bisa diperpanjang. Coba lagi sebentar.'),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Kita tambah 5 menit lagi.')));
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStepIndex});

  final int currentStepIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (
            var index = 0;
            index < CravingSessionProgress.steps.length;
            index++
          ) ...[
            Semantics(
              label:
                  'Langkah ${index + 1}: ${CravingSessionProgress.steps[index].title}',
              child: Chip(
                avatar: Icon(
                  index <= currentStepIndex
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  size: 18,
                  color: index <= currentStepIndex
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                label: Text(CravingSessionProgress.steps[index].title),
              ),
            ),
            if (index < CravingSessionProgress.steps.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(Icons.arrow_forward, size: 16),
              ),
          ],
        ],
      ),
    );
  }
}

class _IntensitySelector extends StatelessWidget {
  const _IntensitySelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (var intensity = 1; intensity <= 5; intensity++)
          ChoiceChip(
            label: Text('$intensity'),
            selected: value == intensity,
            onSelected: onChanged == null
                ? null
                : (selected) {
                    if (selected) {
                      onChanged!(intensity);
                    }
                  },
          ),
      ],
    );
  }
}
