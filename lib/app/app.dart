import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../features/settings/presentation/controllers/settings_providers.dart';

class SerenityApp extends ConsumerWidget {
  const SerenityApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final preferences = ref.watch(settingsPreferencesProvider).valueOrNull;
    ref.watch(notificationControllerProvider);

    return MaterialApp.router(
      title: 'Serenity',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: preferences?.themePreference.themeMode ?? ThemeMode.system,
      routerConfig: router,
    );
  }
}
