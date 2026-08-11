import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';

class OnboardingChoice extends StatelessWidget {
  const OnboardingChoice({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: isSelected
            ? scheme.primary.withValues(alpha: 0.12)
            : scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
          side: BorderSide(
            color: isSelected
                ? scheme.primary
                : Theme.of(context).dividerTheme.color!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.button,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(label)),
                  if (isSelected)
                    Icon(Icons.check_circle, color: scheme.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
