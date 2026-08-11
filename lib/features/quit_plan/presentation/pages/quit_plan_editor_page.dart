import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/time/local_day.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../onboarding/presentation/controllers/onboarding_providers.dart';
import '../../../smoking_log/presentation/controllers/smoking_log_providers.dart';
import '../../domain/entities/quit_plan.dart';
import '../controllers/quit_plan_providers.dart';

class QuitPlanEditorPage extends ConsumerStatefulWidget {
  const QuitPlanEditorPage({super.key});

  @override
  ConsumerState<QuitPlanEditorPage> createState() => _QuitPlanEditorPageState();
}

class _QuitPlanEditorPageState extends ConsumerState<QuitPlanEditorPage> {
  final _supportPersonController = TextEditingController();
  final _cravingActionController = TextEditingController();
  final _strategyControllers = <String, TextEditingController>{};
  final _selectedTriggerIds = <String>{};
  DateTime? _quitDate;
  String? _motivationId;
  String? _loadedPlanId;

  @override
  void dispose() {
    _supportPersonController.dispose();
    _cravingActionController.dispose();
    for (final controller in _strategyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(quitPlanProvider);
    final motivations = ref.watch(_planMotivationsProvider);
    final triggers = ref.watch(triggerTagsProvider);
    final saveState = ref.watch(quitPlanControllerProvider);
    final plan = planState.valueOrNull;
    final now = ref.watch(quitPlanClockProvider)();
    _loadPlan(plan);
    final theme = Theme.of(context);

    return AppScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Kembali',
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Rencana berhenti',
                        style: theme.textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Buat rencana yang terasa realistis untukmu. Kamu bisa mengubahnya kapan saja.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                _PlanStatusCard(plan: plan),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal berhenti',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Pilih hari yang ingin kamu mulai. Hari ini juga boleh.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: saveState.isLoading ? null : _pickQuitDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(_formatDate(_quitDate ?? now)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alasan utama', style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Pilih alasan yang sudah kamu simpan. Ini tetap privat di perangkatmu.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      motivations.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) =>
                            const Text('Alasan belum bisa dimuat.'),
                        data: (items) => items.isEmpty
                            ? const Text(
                                'Belum ada alasan tersimpan dari onboarding.',
                              )
                            : DropdownButtonFormField<String?>(
                                initialValue: _motivationId,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Alasan utama',
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Pilih nanti'),
                                  ),
                                  for (final motivation in items)
                                    DropdownMenuItem<String?>(
                                      value: motivation.id,
                                      child: Text(
                                        motivation.text,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                                onChanged: saveState.isLoading
                                    ? null
                                    : (value) =>
                                          setState(() => _motivationId = value),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemicu terbesar dan rencanamu',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Pilih sampai tiga pemicu, lalu tulis langkah kecil yang ingin dicoba.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      triggers.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) =>
                            const Text('Pemicu belum bisa dimuat.'),
                        data: _triggerEditor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saat craving datang',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _cravingActionController,
                        enabled: !saveState.isLoading,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText:
                              'Contoh: buka SOS, minum air, lalu berjalan sebentar',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orang pendukung (opsional)',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _supportPersonController,
                        enabled: !saveState.isLoading,
                        decoration: const InputDecoration(
                          hintText: 'Nama atau cara menghubungi mereka',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: plan == null ? 'Simpan rencana' : 'Simpan perubahan',
                  onPressed: saveState.isLoading ? null : () => _save(plan),
                ),
                if (plan?.status == QuitPlanStatus.active) ...[
                  const SizedBox(height: AppSpacing.md),
                  SecondaryButton(
                    label: 'Jeda rencana',
                    onPressed: saveState.isLoading ? null : _pause,
                  ),
                ],
                if (plan?.status == QuitPlanStatus.paused) ...[
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: 'Lanjutkan rencana',
                    onPressed: saveState.isLoading ? null : _resume,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _triggerEditor(List<dynamic> triggers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final trigger in triggers)
              ChoiceChip(
                label: Text(trigger.name),
                selected: _selectedTriggerIds.contains(trigger.id),
                onSelected: (selected) => setState(() {
                  if (selected && _selectedTriggerIds.length < 3) {
                    _selectedTriggerIds.add(trigger.id);
                    _strategyControllers.putIfAbsent(
                      trigger.id,
                      TextEditingController.new,
                    );
                  } else if (!selected) {
                    _selectedTriggerIds.remove(trigger.id);
                  }
                }),
              ),
          ],
        ),
        for (final trigger in triggers.where(
          (item) => _selectedTriggerIds.contains(item.id),
        )) ...[
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _strategyControllers[trigger.id],
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Saat ${trigger.name.toString().toLowerCase()}',
            ),
          ),
        ],
      ],
    );
  }

  void _loadPlan(QuitPlan? plan) {
    if (plan == null || _loadedPlanId == plan.id) {
      return;
    }
    _loadedPlanId = plan.id;
    _quitDate = plan.quitDate;
    _motivationId = plan.primaryMotivation?.id;
    _supportPersonController.text = plan.supportPerson ?? '';
    for (final strategy in plan.strategies) {
      if (strategy.trigger == null) {
        _cravingActionController.text = strategy.action;
      } else {
        _selectedTriggerIds.add(strategy.trigger!.id);
        _strategyControllers[strategy.trigger!.id] = TextEditingController(
          text: strategy.action,
        );
      }
    }
  }

  Future<void> _pickQuitDate() async {
    final now = ref.read(quitPlanClockProvider)();
    final selected = await showDatePicker(
      context: context,
      initialDate: _quitDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (selected != null && mounted) {
      setState(() => _quitDate = startOfLocalDay(selected));
    }
  }

  Future<void> _save(QuitPlan? plan) async {
    final missingAction = _selectedTriggerIds.any(
      (id) => _strategyControllers[id]!.text.trim().isEmpty,
    );
    if (missingAction) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tambahkan satu langkah untuk setiap pemicu yang dipilih.',
          ),
        ),
      );
      return;
    }
    final strategies = <SaveQuitPlanStrategyInput>[
      for (final triggerId in _selectedTriggerIds)
        SaveQuitPlanStrategyInput(
          triggerId: triggerId,
          action: _strategyControllers[triggerId]!.text,
        ),
      if (_cravingActionController.text.trim().isNotEmpty)
        SaveQuitPlanStrategyInput(action: _cravingActionController.text),
    ];
    await ref
        .read(quitPlanControllerProvider.notifier)
        .save(
          SaveQuitPlanInput(
            id: plan?.id,
            quitDate:
                _quitDate ?? startOfLocalDay(ref.read(quitPlanClockProvider)()),
            primaryMotivationId: _motivationId,
            supportPerson: _supportPersonController.text,
            strategies: strategies,
          ),
        );
    if (!mounted) {
      return;
    }
    if (ref.read(quitPlanControllerProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rencana belum bisa disimpan. Coba lagi sebentar.'),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rencanamu tersimpan. Kamu bisa mengubahnya kapan saja.'),
      ),
    );
  }

  Future<void> _pause() async {
    await ref.read(quitPlanControllerProvider.notifier).pause();
  }

  Future<void> _resume() async {
    await ref.read(quitPlanControllerProvider.notifier).resume();
  }

  String _formatDate(DateTime date) {
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return '${names[date.weekday - 1]}, ${date.day}/${date.month}/${date.year}';
  }
}

class _PlanStatusCard extends StatelessWidget {
  const _PlanStatusCard({required this.plan});

  final QuitPlan? plan;

  @override
  Widget build(BuildContext context) {
    final message = switch (plan?.status) {
      QuitPlanStatus.draft =>
        'Rencana akan aktif pada tanggal yang kamu pilih.',
      QuitPlanStatus.active =>
        'Rencana aktif. Hari ini cukup fokus pada hari ini.',
      QuitPlanStatus.paused =>
        'Rencana sedang dijeda. Kamu dapat melanjutkannya saat siap.',
      QuitPlanStatus.completed => 'Rencana ini sudah selesai.',
      null => 'Mulai dengan tanggal dan langkah kecil yang terasa mungkin.',
    };
    return AppCard(child: Text(message));
  }
}

enum SlipResolution { continueQuitting, adjustPlan }

class SlipSupportSheet extends StatelessWidget {
  const SlipSupportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tercatat.', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Satu kejadian ini tidak menghapus semua hal yang sudah kamu pelajari.',
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Apa yang terjadi sebelumnya? Kalau mau, pemicu bisa kamu tandai pada catatan rokok tadi.',
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Lanjut berhenti dari sekarang',
              onPressed: () =>
                  Navigator.of(context).pop(SlipResolution.continueQuitting),
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: 'Atur ulang rencana',
              onPressed: () =>
                  Navigator.of(context).pop(SlipResolution.adjustPlan),
            ),
          ],
        ),
      ),
    );
  }
}

final _planMotivationsProvider = FutureProvider((ref) {
  return ref.watch(profileRepositoryProvider).getMotivations();
});
