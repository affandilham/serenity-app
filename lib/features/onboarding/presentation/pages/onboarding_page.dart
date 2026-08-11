import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/goal_type.dart';
import '../controllers/onboarding_providers.dart';
import '../widgets/onboarding_choice.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const _motivationCategories = [
    'Kesehatan',
    'Keluarga',
    'Pasangan',
    'Anak',
    'Keuangan',
    'Kebebasan',
    'Lainnya',
  ];

  final _pageController = PageController();
  final _patternFormKey = GlobalKey<FormState>();
  final _baselineController = TextEditingController();
  final _packPriceController = TextEditingController();
  final _cigarettesPerPackController = TextEditingController();
  final _firstCigaretteController = TextEditingController();
  final _motivationController = TextEditingController();
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _baselineController.dispose();
    _packPriceController.dispose();
    _cigarettesPerPackController.dispose();
    _firstCigaretteController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(onboardingSaveProvider);
    ref.listen<AsyncValue<void>>(onboardingSaveProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil belum tersimpan. Coba lagi sebentar.'),
          ),
        );
      }
    });

    final textTheme = Theme.of(context).textTheme;
    return AppScaffold(
      child: Column(
        children: [
          _OnboardingProgress(currentStep: _currentStep),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _OnboardingStep(child: _WelcomeStep(textTheme: textTheme)),
                _OnboardingStep(
                  child: _CurrentPatternStep(
                    formKey: _patternFormKey,
                    baselineController: _baselineController,
                    packPriceController: _packPriceController,
                    cigarettesPerPackController: _cigarettesPerPackController,
                    firstCigaretteController: _firstCigaretteController,
                  ),
                ),
                _OnboardingStep(child: _GoalStep()),
                _OnboardingStep(
                  child: _MotivationStep(
                    categories: _motivationCategories,
                    controller: _motivationController,
                  ),
                ),
                _OnboardingStep(child: _FinishStep(textTheme: textTheme)),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: SecondaryButton(
                        label: 'Kembali',
                        onPressed: saveState.isLoading ? null : _goBack,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: PrimaryButton(
                      label: _currentStep == 0
                          ? 'Mulai'
                          : _currentStep == 4
                          ? 'Simpan dan mulai'
                          : 'Lanjut',
                      onPressed: saveState.isLoading ? null : _continue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _continue() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_currentStep == 1 &&
        !(_patternFormKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentStep == 1) {
      ref
          .read(onboardingDraftProvider.notifier)
          .updatePattern(
            baselineCigarettesPerDay: _parseNumber(_baselineController),
            cigarettesPerPack: _parseNumber(_cigarettesPerPackController),
            packPrice: _parseNumber(_packPriceController),
            firstCigaretteAfterWakingMinutes: _parseNumber(
              _firstCigaretteController,
            ),
          );
    }
    if (_currentStep == 2 &&
        ref.read(onboardingDraftProvider).goalType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih arah yang paling pas untukmu.')),
      );
      return;
    }
    if (_currentStep == 3) {
      ref
          .read(onboardingDraftProvider.notifier)
          .updateMotivation(
            category: ref.read(onboardingDraftProvider).motivationCategory,
            text: _motivationController.text,
          );
    }
    if (_currentStep == 4) {
      await ref.read(onboardingSaveProvider.notifier).save();
      return;
    }

    setState(() => _currentStep += 1);
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _goBack() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _currentStep -= 1);
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  int? _parseNumber(TextEditingController controller) {
    final text = controller.text.trim().replaceAll('.', '').replaceAll(',', '');
    return text.isEmpty ? null : int.tryParse(text);
  }
}

class _OnboardingProgress extends StatelessWidget {
  const _OnboardingProgress({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      child: Semantics(
        label: 'Langkah ${currentStep + 1} dari 5',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Serenity', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: (currentStep + 1) / 5),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xxxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: child,
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xxxl),
        Text(
          'Kita nggak perlu menyelesaikan semuanya hari ini.',
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Mulai dari mengenali pola merokokmu.',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        const AppCard(
          child: Text(
            'Semua jawabanmu bersifat privat dan disimpan hanya di perangkat ini.',
          ),
        ),
      ],
    );
  }
}

class _CurrentPatternStep extends StatelessWidget {
  const _CurrentPatternStep({
    required this.formKey,
    required this.baselineController,
    required this.packPriceController,
    required this.cigarettesPerPackController,
    required this.firstCigaretteController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController baselineController;
  final TextEditingController packPriceController;
  final TextEditingController cigarettesPerPackController;
  final TextEditingController firstCigaretteController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seperti apa kebiasaanmu sekarang?',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tidak perlu tepat sekali. Perkiraan yang terasa jujur sudah cukup.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _NumberField(
            controller: baselineController,
            label: 'Rata-rata batang per hari',
            hint: 'Contoh: 12',
            required: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          _NumberField(
            controller: packPriceController,
            label: 'Harga sebungkus',
            hint: 'Contoh: 30000',
            prefix: 'Rp ',
          ),
          const SizedBox(height: AppSpacing.lg),
          _NumberField(
            controller: cigarettesPerPackController,
            label: 'Isi batang per bungkus',
            hint: 'Contoh: 16',
          ),
          const SizedBox(height: AppSpacing.lg),
          _NumberField(
            controller: firstCigaretteController,
            label: 'Rokok pertama setelah bangun',
            hint: 'Dalam menit, contoh: 30',
            allowZero: true,
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.hint,
    this.prefix,
    this.required = false,
    this.allowZero = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? prefix;
  final bool required;
  final bool allowZero;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix,
      ),
      validator: (value) {
        final parsed = int.tryParse(value?.trim() ?? '');
        if (required && parsed == null) {
          return 'Isi perkiraan batang per hari terlebih dahulu.';
        }
        if (parsed != null && (allowZero ? parsed < 0 : parsed <= 0)) {
          return 'Masukkan angka yang lebih dari nol.';
        }
        return null;
      },
    );
  }
}

class _GoalStep extends ConsumerWidget {
  const _GoalStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(
      onboardingDraftProvider.select((draft) => draft.goalType),
    );
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kamu ingin mulai dari mana?', style: textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Kamu selalu bisa menyesuaikan arahmu nanti.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xxl),
        for (final goal in GoalType.values) ...[
          OnboardingChoice(
            label: goal.label,
            isSelected: selectedGoal == goal,
            onTap: () =>
                ref.read(onboardingDraftProvider.notifier).selectGoal(goal),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _MotivationStep extends ConsumerWidget {
  const _MotivationStep({required this.categories, required this.controller});

  final List<String> categories;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(
      onboardingDraftProvider.select((draft) => draft.motivationCategory),
    );
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kenapa kamu ingin berhenti?', style: textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Pilih yang terasa dekat, atau lewati dulu. Data ini privat dan disimpan lokal.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final category in categories)
              ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (_) => ref
                    .read(onboardingDraftProvider.notifier)
                    .updateMotivation(
                      category: selectedCategory == category ? null : category,
                      text: controller.text,
                    ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: controller,
          minLines: 4,
          maxLines: 6,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            labelText: 'Alasanmu',
            hintText: 'Tulis dengan kata-katamu sendiri...',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}

class _FinishStep extends StatelessWidget {
  const _FinishStep({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xxxl),
        Text('Tidak harus sempurna.', style: textTheme.displaySmall),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Yang penting kita mulai mencatat dengan jujur.',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        const AppCard(
          child: Text(
            'Profilmu disimpan secara lokal. Kamu tetap memegang kendali atas datamu.',
          ),
        ),
      ],
    );
  }
}
