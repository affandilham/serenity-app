import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../domain/entities/smoking_log.dart';
import '../controllers/smoking_log_providers.dart';

class QuickSmokingLogSheet extends ConsumerStatefulWidget {
  const QuickSmokingLogSheet({super.key, this.initialCravingLevel = 3});

  final int initialCravingLevel;

  @override
  ConsumerState<QuickSmokingLogSheet> createState() =>
      _QuickSmokingLogSheetState();
}

class _QuickSmokingLogSheetState extends ConsumerState<QuickSmokingLogSheet> {
  final _selectedTriggerIds = <String>{};
  final _noteController = TextEditingController();
  late final DateTime _openedAt;
  late int _cravingLevel;

  @override
  void initState() {
    super.initState();
    _openedAt = ref.read(smokingLogClockProvider)();
    _cravingLevel = widget.initialCravingLevel;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(smokingLogControllerProvider);
    final triggers = ref.watch(triggerTagsProvider);
    final time = _formatTime(_openedAt);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: const BorderRadius.all(AppRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Catat rokok',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sekarang · $time',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Apa yang memicunya? (opsional)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              triggers.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) =>
                    const Text('Pilihan pemicu belum bisa dimuat.'),
                data: _buildTriggerChoices,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Keinginan merokok: $_cravingLevel dari 5',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Slider(
                value: _cravingLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_cravingLevel',
                onChanged: saveState.isLoading
                    ? null
                    : (value) => setState(() => _cravingLevel = value.round()),
              ),
              TextField(
                controller: _noteController,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Contoh: sedang menunggu teman',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Catat',
                onPressed: saveState.isLoading ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTriggerChoices(List<TriggerTag> triggers) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final trigger in triggers)
          ChoiceChip(
            label: Text(trigger.name),
            selected: _selectedTriggerIds.contains(trigger.id),
            onSelected: (selected) => setState(() {
              if (selected) {
                _selectedTriggerIds.add(trigger.id);
              } else {
                _selectedTriggerIds.remove(trigger.id);
              }
            }),
          ),
      ],
    );
  }

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref
        .read(smokingLogControllerProvider.notifier)
        .addQuickLog(
          triggerIds: _selectedTriggerIds,
          cravingLevel: _cravingLevel,
          note: _noteController.text,
        );
    if (!mounted) {
      return;
    }
    if (ref.read(smokingLogControllerProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan belum tersimpan. Coba lagi sebentar.'),
        ),
      );
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tercatat. Kita pakai ini untuk memahami polamu.'),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
