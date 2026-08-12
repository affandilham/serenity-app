import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../craving/presentation/pages/craving_sos_page.dart';
import '../../../craving/presentation/controllers/craving_providers.dart';
import '../../../insights/presentation/pages/insights_page.dart';
import '../../../quit_plan/domain/entities/quit_plan.dart';
import '../../../quit_plan/presentation/controllers/quit_plan_providers.dart';
import '../../../quit_plan/presentation/pages/quit_plan_editor_page.dart';
import '../../domain/entities/smoking_log.dart';
import '../controllers/smoking_log_providers.dart';
import '../widgets/quick_smoking_log_sheet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quitPlanControllerProvider.notifier).activateIfDue();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(quitPlanProvider).valueOrNull;
    if (plan?.status == QuitPlanStatus.active) {
      return _QuitDayHome(plan: plan!);
    }
    final textTheme = Theme.of(context).textTheme;
    return AppScaffold(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xxl,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hari ini', style: textTheme.displaySmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Kita lihat polanya, pelan-pelan.',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _TodaySmokingCountCard(),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: '+ Catat rokok',
                    onPressed: _openSmokingLog,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SecondaryButton(
                    label: 'Saya lagi ngidam',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CravingSosPage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: _openQuitPlan,
                    child: const Text('Buat rencana berhenti'),
                  ),
                  TextButton(
                    onPressed: _openInsights,
                    child: const Text('Lihat insight'),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Pola hari ini', style: textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          const _TodaySmokingTimeline(),
        ],
      ),
    );
  }

  Future<void> _openSmokingLog() async {
    final result = await showModalBottomSheet<QuickSmokingLogResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const QuickSmokingLogSheet(),
    );
    if (!mounted || result == null) {
      return;
    }
    if (result.isSlip) {
      await _showSlipSupport();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tercatat. Kita pakai ini untuk memahami polamu.'),
      ),
    );
  }

  Future<void> _showSlipSupport() async {
    final resolution = await showModalBottomSheet<SlipResolution>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SlipSupportSheet(),
    );
    if (!mounted) {
      return;
    }
    if (resolution == SlipResolution.adjustPlan) {
      await _openQuitPlan();
    }
  }

  Future<void> _openQuitPlan() => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const QuitPlanEditorPage()));

  Future<void> _openInsights() => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const InsightsPage()));
}

class _QuitDayHome extends ConsumerWidget {
  const _QuitDayHome({required this.plan});

  final QuitPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(quitProgressProvider);
    final cravings = ref.watch(cravingSessionsProvider).valueOrNull ?? const [];
    final passedCravings = cravings
        .where(
          (session) =>
              session.outcome?.name == 'passed' &&
              !session.startedAt.isBefore(plan.quitDate),
        )
        .length;
    return AppScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hari ini',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hari ini cukup satu tujuan:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'tidak merokok hari ini.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _QuitMetricCard(
                  value: _formatDuration(progress?.currentSmokeFreeDuration),
                  label: 'sejak rokok terakhir',
                ),
                const SizedBox(height: AppSpacing.md),
                _QuitMetricCard(
                  value: '$passedCravings craving',
                  label: 'berhasil dilewati',
                ),
                if (plan.primaryMotivation != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Text('Alasanmu: “${plan.primaryMotivation!.text}”'),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Saya Lagi Ngidam',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CravingSosPage(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Catat rokok',
                  onPressed: () async {
                    final result =
                        await showModalBottomSheet<QuickSmokingLogResult>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const QuickSmokingLogSheet(),
                        );
                    if (!context.mounted || result?.isSlip != true) {
                      return;
                    }
                    final resolution =
                        await showModalBottomSheet<SlipResolution>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const SlipSupportSheet(),
                        );
                    if (context.mounted &&
                        resolution == SlipResolution.adjustPlan) {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const QuitPlanEditorPage(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const InsightsPage(),
                    ),
                  ),
                  child: const Text('Lihat insight'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const QuitPlanEditorPage(),
                    ),
                  ),
                  child: const Text('Lihat atau ubah rencana'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '—';
    }
    if (duration.inHours >= 24) {
      return '${duration.inDays} hari';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours} jam';
    }
    return '${duration.inMinutes} menit';
  }
}

class _QuitMetricCard extends StatelessWidget {
  const _QuitMetricCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(label),
        ],
      ),
    );
  }
}

class _TodaySmokingCountCard extends ConsumerWidget {
  const _TodaySmokingCountCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(todaySmokingCountProvider);
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      child: count.when(
        loading: () => const SizedBox(
          height: 66,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Text(
          'Jumlah hari ini belum bisa dimuat.',
          style: textTheme.bodyLarge,
        ),
        data: (value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value batang', style: textTheme.displaySmall),
            const SizedBox(height: AppSpacing.xs),
            Text('hari ini', style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _TodaySmokingTimeline extends ConsumerWidget {
  const _TodaySmokingTimeline();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(todaySmokingLogsProvider);
    return logs.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text('Riwayat hari ini belum bisa dimuat.'),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const SliverToBoxAdapter(child: _EmptyTimeline());
        }
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.xxl,
          ),
          sliver: SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _SmokingTimelineItem(log: items[index]),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      child: AppCard(
        child: Text(
          'Belum ada catatan hari ini. Kalau kamu merokok nanti, catat saja saat itu terjadi.',
        ),
      ),
    );
  }
}

class _SmokingTimelineItem extends StatelessWidget {
  const _SmokingTimelineItem({required this.log});

  final SmokingLog log;

  @override
  Widget build(BuildContext context) {
    final localTime = log.smokedAt.toLocal();
    final time =
        '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
    final triggers = log.triggers.map((trigger) => trigger.name).join(' · ');
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(time, style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              triggers.isEmpty ? 'Catatan rokok' : triggers,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
