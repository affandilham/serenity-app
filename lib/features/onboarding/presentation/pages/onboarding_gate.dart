import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../smoking_log/presentation/pages/home_page.dart';
import '../controllers/onboarding_providers.dart';
import 'onboarding_page.dart';

class OnboardingGate extends ConsumerWidget {
  const OnboardingGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    return profile.when(
      loading: () =>
          const AppScaffold(child: Center(child: CircularProgressIndicator())),
      error: (error, _) => _OnboardingLoadError(
        onRetry: () => ref.invalidate(userProfileProvider),
      ),
      data: (value) => value?.onboardingCompleted == true
          ? const HomePage()
          : const OnboardingPage(),
    );
  }
}

class _OnboardingLoadError extends StatelessWidget {
  const _OnboardingLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum bisa memuat profilmu.',
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Coba lagi sebentar. Data tetap tersimpan di perangkatmu.',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(label: 'Coba lagi', onPressed: onRetry),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
