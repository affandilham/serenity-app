import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../craving/domain/entities/craving_session.dart';
import '../../domain/entities/insight_snapshot.dart';
import '../controllers/insights_providers.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(insightsSnapshotProvider);
    final days = ref.watch(insightsRangeDaysProvider);
    return AppScaffold(
      child: SafeArea(
        child: snapshot == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xxl,
                  AppSpacing.xl,
                  AppSpacing.xxl,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Insight',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Dari catatanmu, kita lihat yang paling membantu.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _RangeSelector(selectedDays: days),
                      const SizedBox(height: AppSpacing.xl),
                      _DailyCigaretteCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.lg),
                      _TimePatternCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.lg),
                      _TriggerCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.lg),
                      _CravingCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.lg),
                      _JourneyCard(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _RangeSelector extends ConsumerWidget {
  const _RangeSelector({required this.selectedDays});

  final int selectedDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 7, label: Text('7 hari')),
        ButtonSegment(value: 30, label: Text('30 hari')),
      ],
      selected: {selectedDays},
      onSelectionChanged: (value) {
        ref.read(insightsRangeDaysProvider.notifier).select(value.single);
      },
    );
  }
}

class _DailyCigaretteCard extends StatelessWidget {
  const _DailyCigaretteCard({required this.snapshot});

  final InsightSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final total = snapshot.dailyCigarettes.fold<int>(
      0,
      (sum, point) => sum + point.count,
    );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batang per hari',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            total == 0
                ? 'Belum ada catatan rokok di rentang ini.'
                : '$total batang tercatat di rentang ini.',
          ),
          const SizedBox(height: AppSpacing.lg),
          if (snapshot.dailyCigarettes.length > 7)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'Cubit untuk zoom, lalu geser ke samping untuk melihat tanggal lainnya.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          _DailyBars(points: snapshot.dailyCigarettes),
        ],
      ),
    );
  }
}

class _DailyBars extends StatelessWidget {
  const _DailyBars({required this.points});

  final List<DailyCigaretteInsight> points;

  @override
  Widget build(BuildContext context) {
    final maximum = points.fold<int>(
      0,
      (max, point) => point.count > max ? point.count : max,
    );
    final color = Theme.of(context).colorScheme.primary;
    return _ScrollableTimeSeries(
      pointCount: points.length,
      height: 126,
      builder: (pointWidth) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in points)
            SizedBox(
              width: pointWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: '${_dayLabel(point.day)}: ${point.count} batang',
                      child: Semantics(
                        label: '${_dayLabel(point.day)}, ${point.count} batang',
                        child: Container(
                          height: maximum == 0
                              ? 3
                              : 78 * point.count / maximum + 3,
                          decoration: BoxDecoration(
                            color: point.count == 0
                                ? color.withValues(alpha: 0.18)
                                : color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _shortDayLabel(point.day),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimePatternCard extends StatelessWidget {
  const _TimePatternCard({required this.snapshot});

  final InsightSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ranked = [...snapshot.timeOfDayPatterns]
      ..sort((a, b) => b.count.compareTo(a.count));
    final top = ranked.first;
    final hasData = top.count > 0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pola waktu', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hasData
                ? 'Kamu paling sering merokok antara ${top.label}.'
                : 'Belum cukup data untuk melihat pola jam merokokmu.',
          ),
          if (hasData) ...[
            const SizedBox(height: AppSpacing.lg),
            _LabeledBars(
              rows: snapshot.timeOfDayPatterns
                  .map((item) => _BarRow(item.label, item.count))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _TriggerCard extends StatelessWidget {
  const _TriggerCard({required this.snapshot});

  final InsightSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final top = snapshot.triggerUsage.firstOrNull;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pemicu yang muncul',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            top == null
                ? 'Belum ada pemicu yang tercatat. Kalau terasa pas, tambahkan saat mencatat rokok.'
                : '${top.name} muncul pada ${top.percentageOfLogs.round()}% catatanmu di rentang ini.',
          ),
          if (top != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _LabeledBars(
              rows: snapshot.triggerUsage
                  .take(4)
                  .map((item) => _BarRow(item.name, item.count))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CravingCard extends StatelessWidget {
  const _CravingCard({required this.snapshot});

  final InsightSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final craving = snapshot.craving;
    if (craving.totalCompleted == 0) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Craving', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Belum ada sesi craving yang selesai. SOS akan membantumu melihat pola ini saat kamu siap.',
            ),
          ],
        ),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Craving', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Rata-rata craving saat mulai: ${_score(craving.averageInitialIntensity)} / 5',
          ),
          if (craving.averageFinalIntensity != null)
            Text(
              'Rata-rata saat selesai: ${_score(craving.averageFinalIntensity)} / 5',
            ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Intensitas awal per hari',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (craving.trend.length > 7)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'Cubit untuk zoom, lalu geser ke samping untuk melihat tanggal lainnya.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          _CravingTrend(points: craving.trend),
          const SizedBox(height: AppSpacing.lg),
          _LabeledBars(
            rows: [
              _BarRow('Dilewati', craving.outcomes[CravingOutcome.passed] ?? 0),
              _BarRow('Menunda', craving.outcomes[CravingOutcome.delayed] ?? 0),
              _BarRow('Merokok', craving.outcomes[CravingOutcome.smoked] ?? 0),
              _BarRow(
                'Berhenti di tengah',
                craving.outcomes[CravingOutcome.abandoned] ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CravingTrend extends StatelessWidget {
  const _CravingTrend({required this.points});

  final List<CravingTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return _ScrollableTimeSeries(
      pointCount: points.length,
      height: 114,
      builder: (pointWidth) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in points)
            SizedBox(
              width: pointWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Semantics(
                      label: point.averageInitialIntensity == null
                          ? '${_dayLabel(point.day)}, belum ada sesi'
                          : '${_dayLabel(point.day)}, intensitas ${_score(point.averageInitialIntensity)} dari 5',
                      child: Container(
                        height: point.averageInitialIntensity == null
                            ? 3
                            : 62 * point.averageInitialIntensity! / 5 + 3,
                        decoration: BoxDecoration(
                          color: point.averageInitialIntensity == null
                              ? color.withValues(alpha: 0.18)
                              : color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _shortDayLabel(point.day),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScrollableTimeSeries extends StatefulWidget {
  const _ScrollableTimeSeries({
    required this.pointCount,
    required this.height,
    required this.builder,
  });

  final int pointCount;
  final double height;
  final Widget Function(double pointWidth) builder;

  @override
  State<_ScrollableTimeSeries> createState() => _ScrollableTimeSeriesState();
}

class _ScrollableTimeSeriesState extends State<_ScrollableTimeSeries> {
  final _scrollController = ScrollController();
  late bool _wasScrollable = widget.pointCount > 7;

  @override
  void initState() {
    super.initState();
    if (_wasScrollable) {
      _showLatestDate();
    }
  }

  @override
  void didUpdateWidget(covariant _ScrollableTimeSeries oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isScrollable = widget.pointCount > 7;
    if (isScrollable && !_wasScrollable) {
      _showLatestDate();
    }
    _wasScrollable = isScrollable;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showLatestDate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = widget.pointCount > 7
            ? widget.pointCount * 36.0
            : constraints.maxWidth;
        final pointWidth = chartWidth / widget.pointCount;
        final chart = SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: chartWidth, child: widget.builder(pointWidth)),
        );
        return SizedBox(
          height: widget.height,
          child: Semantics(
            label: widget.pointCount > 7
                ? 'Cubit untuk memperbesar grafik, lalu geser ke samping untuk melihat semua tanggal.'
                : null,
            child: widget.pointCount > 7
                ? InteractiveViewer(
                    panEnabled: false,
                    minScale: 1,
                    maxScale: 2.5,
                    boundaryMargin: const EdgeInsets.symmetric(horizontal: 160),
                    child: chart,
                  )
                : chart,
          ),
        );
      },
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({required this.snapshot});

  final InsightSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final journey = snapshot.journey;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perjalananmu', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          if (journey.currentSmokeFreeDuration != null)
            _MetricRow(
              'Bebas rokok saat ini',
              _formatDuration(journey.currentSmokeFreeDuration!),
            ),
          if (journey.longestSmokeFreeDuration != null)
            _MetricRow(
              'Periode terpanjang',
              _formatDuration(journey.longestSmokeFreeDuration!),
            ),
          _MetricRow(
            'Rokok yang dihindari',
            '${journey.cigarettesAvoided} batang',
          ),
          _MetricRow(
            'Hari di bawah patokan awal',
            '${journey.daysBelowBaseline} hari',
          ),
          _MetricRow(
            'Sesi craving selesai',
            '${journey.totalCravingSessionsCompleted} sesi',
          ),
          if (journey.moneyNotSpent != null)
            _MetricRow(
              'Perkiraan uang tidak dibelanjakan',
              _rupiah(journey.moneyNotSpent!),
            ),
          if (journey.moneyNotSpent == null)
            const Text(
              'Harga per bungkus belum tersedia, jadi uang belum dihitung.',
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Rokok yang dihindari dan uang dihitung dari hari lokal yang sudah selesai.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );
}

class _LabeledBars extends StatelessWidget {
  const _LabeledBars({required this.rows});

  final List<_BarRow> rows;

  @override
  Widget build(BuildContext context) {
    final maximum = rows.fold<int>(
      0,
      (max, row) => row.value > max ? row.value : max,
    );
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.label),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: '${row.label}, ${row.value}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: maximum == 0 ? 0 : row.value / maximum,
                            minHeight: 10,
                            color: color,
                            backgroundColor: color.withValues(alpha: 0.14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('${row.value}'),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BarRow {
  const _BarRow(this.label, this.value);

  final String label;
  final int value;
}

String _shortDayLabel(DateTime day) => '${day.day}/${day.month}';
String _dayLabel(DateTime day) => '${day.day}/${day.month}/${day.year}';
String _score(double? value) => value == null ? '—' : value.toStringAsFixed(1);
String _formatDuration(Duration value) => value.inHours >= 24
    ? '${value.inDays} hari'
    : value.inHours > 0
    ? '${value.inHours} jam'
    : '${value.inMinutes} menit';

String _rupiah(double amount) {
  final rounded = amount.round().toString();
  final buffer = StringBuffer('Rp');
  for (var index = 0; index < rounded.length; index++) {
    if (index > 0 && (rounded.length - index) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(rounded[index]);
  }
  return buffer.toString();
}
