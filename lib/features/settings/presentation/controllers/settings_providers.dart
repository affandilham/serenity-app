import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/notifications/flutter_notification_service.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../onboarding/presentation/controllers/onboarding_providers.dart';
import '../../../quit_plan/domain/entities/quit_plan.dart';
import '../../../quit_plan/presentation/controllers/quit_plan_providers.dart';
import '../../data/repositories/drift_settings_repository.dart';
import '../../domain/entities/settings_preferences.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/device_export_service.dart';
import '../../domain/services/reset_service.dart';
import '../../domain/services/serenity_export_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return DriftSettingsRepository(ref.watch(appDatabaseProvider));
});

final settingsPreferencesProvider = StreamProvider<SettingsPreferences>((ref) {
  return ref.watch(settingsRepositoryProvider).watchPreferences();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return FlutterNotificationService();
});

final serenityExportServiceProvider = Provider<SerenityExportService>((ref) {
  return SerenityExportService(ref.watch(appDatabaseProvider));
});

final deviceExportServiceProvider = Provider<DeviceExportService>((ref) {
  return DeviceExportService(ref.watch(serenityExportServiceProvider));
});

final resetServiceProvider = Provider<ResetService>((ref) {
  return ResetService(
    ref.watch(appDatabaseProvider),
    ref.watch(notificationServiceProvider),
  );
});

final notificationControllerProvider =
    AsyncNotifierProvider<NotificationController, void>(
      NotificationController.new,
    );

class NotificationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    ref.listen(settingsPreferencesProvider, (_, next) {
      final preferences = next.valueOrNull;
      if (preferences != null) {
        _sync(preferences, ref.read(quitPlanProvider).valueOrNull);
      }
    });
    ref.listen(quitPlanProvider, (_, next) {
      final preferences = ref.read(settingsPreferencesProvider).valueOrNull;
      if (preferences != null) {
        _sync(preferences, next.valueOrNull);
      }
    });
    final preferences = await ref
        .read(settingsRepositoryProvider)
        .getPreferences();
    await _sync(
      preferences,
      await ref.read(quitPlanRepositoryProvider).getPlan(),
    );
  }

  Future<void> setDailyCheckInEnabled(bool enabled) async {
    final preferences = await _preferences();
    if (!enabled) {
      await ref.read(notificationServiceProvider).cancelDailyCheckIn();
      await _save(preferences.copyWith(dailyCheckInEnabled: false));
      return;
    }
    final permissionGranted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    if (!permissionGranted) {
      throw const NotificationPermissionDeniedException();
    }
    final updated = preferences.copyWith(dailyCheckInEnabled: true);
    await _save(updated);
    await ref
        .read(notificationServiceProvider)
        .scheduleDailyCheckIn(updated.dailyCheckInTime);
  }

  Future<void> setDailyCheckInTime(ReminderTime time) async {
    final updated = (await _preferences()).copyWith(dailyCheckInTime: time);
    await _save(updated);
    if (updated.dailyCheckInEnabled) {
      await ref.read(notificationServiceProvider).scheduleDailyCheckIn(time);
    }
  }

  Future<void> setQuitDayReminderEnabled(bool enabled) async {
    final preferences = await _preferences();
    if (!enabled) {
      await ref.read(notificationServiceProvider).cancelQuitDay();
      await _save(preferences.copyWith(quitDayReminderEnabled: false));
      return;
    }
    final plan = await ref.read(quitPlanRepositoryProvider).getPlan();
    if (plan == null) {
      throw StateError(
        'Buat rencana berhenti sebelum menyalakan pengingat ini.',
      );
    }
    final permissionGranted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    if (!permissionGranted) {
      throw const NotificationPermissionDeniedException();
    }
    final updated = preferences.copyWith(quitDayReminderEnabled: true);
    await _save(updated);
    await ref.read(notificationServiceProvider).scheduleQuitDay(plan.quitDate);
  }

  Future<void> _save(SettingsPreferences preferences) =>
      ref.read(settingsRepositoryProvider).savePreferences(preferences);

  Future<SettingsPreferences> _preferences() =>
      ref.read(settingsRepositoryProvider).getPreferences();

  Future<void> _sync(SettingsPreferences preferences, QuitPlan? plan) async {
    if (!preferences.dailyCheckInEnabled &&
        !preferences.quitDayReminderEnabled) {
      return;
    }
    final notifications = ref.read(notificationServiceProvider);
    await notifications.initialize();
    if (preferences.dailyCheckInEnabled) {
      await notifications.scheduleDailyCheckIn(preferences.dailyCheckInTime);
    } else {
      await notifications.cancelDailyCheckIn();
    }
    if (preferences.quitDayReminderEnabled && plan != null) {
      await notifications.scheduleQuitDay(plan.quitDate);
    } else {
      await notifications.cancelQuitDay();
    }
  }
}

class NotificationPermissionDeniedException implements Exception {
  const NotificationPermissionDeniedException();
}

final settingsProfileControllerProvider = Provider<SettingsProfileController>((
  ref,
) {
  return SettingsProfileController(ref);
});

class SettingsProfileController {
  SettingsProfileController(this._ref);

  final Ref _ref;

  Future<void> updatePattern({
    required int baselineCigarettesPerDay,
    required int? cigarettesPerPack,
    required int? packPrice,
  }) => _ref
      .read(profileRepositoryProvider)
      .updatePattern(
        baselineCigarettesPerDay: baselineCigarettesPerDay,
        cigarettesPerPack: cigarettesPerPack,
        packPrice: packPrice,
      );
}
