import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/smoking_log.dart';
import '../controllers/smoking_log_providers.dart';
import '../widgets/quick_smoking_log_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const QuickSmokingLogSheet(),
                    ),
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
