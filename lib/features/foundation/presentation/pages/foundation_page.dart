import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';

class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              Text('Serenity', style: textTheme.displaySmall),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Langkah kecil, ruang yang lebih tenang.',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mulai dengan tenang', style: textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Serenity adalah ruang pribadi untuk memahami pola dan '
                      'mendukung perubahanmu, satu langkah pada satu waktu.',
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Small Efforts Restore Ease; New Intentions Transform You.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
