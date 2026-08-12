import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/database/database_provider.dart';
import 'package:serenity_app/core/notifications/notification_service.dart';
import 'package:serenity_app/features/settings/domain/entities/settings_preferences.dart';
import 'package:serenity_app/features/settings/presentation/controllers/settings_providers.dart';

void main() {
  late AppDatabase database;
  late _FakeNotifications notifications;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    notifications = _FakeNotifications();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    database.close();
  });

  test(
    'daily check-in is opt-in, replaces its schedule, and cancels cleanly',
    () async {
      await container.read(notificationControllerProvider.future);
      expect(notifications.initialized, isFalse);

      await container
          .read(notificationControllerProvider.notifier)
          .setDailyCheckInEnabled(true);
      expect(notifications.permissionRequests, 1);
      expect(notifications.dailyTimes, [ReminderTime.dailyDefault]);

      const changedTime = ReminderTime(hour: 21, minute: 30);
      await container
          .read(notificationControllerProvider.notifier)
          .setDailyCheckInTime(changedTime);
      expect(notifications.dailyTimes.last, changedTime);

      await container
          .read(notificationControllerProvider.notifier)
          .setDailyCheckInEnabled(false);
      expect(notifications.dailyCancelCalls, 1);
      expect(
        (await container.read(settingsRepositoryProvider).getPreferences())
            .dailyCheckInEnabled,
        isFalse,
      );
    },
  );

  test(
    'denied permission does not enable notifications or schedule a reminder',
    () async {
      notifications.permissionGranted = false;
      await container.read(notificationControllerProvider.future);

      expect(
        () => container
            .read(notificationControllerProvider.notifier)
            .setDailyCheckInEnabled(true),
        throwsA(isA<NotificationPermissionDeniedException>()),
      );
      expect(notifications.dailyTimes, isEmpty);
      expect(
        (await container.read(settingsRepositoryProvider).getPreferences())
            .dailyCheckInEnabled,
        isFalse,
      );
    },
  );

  test(
    'quit reminder uses the persisted quit date and stable notification category',
    () async {
      final now = DateTime(2026, 8, 12);
      await database
          .into(database.quitPlans)
          .insert(
            QuitPlansCompanion.insert(
              id: 'plan',
              quitDate: now.add(const Duration(days: 5)),
              status: 'draft',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await container.read(notificationControllerProvider.future);

      await container
          .read(notificationControllerProvider.notifier)
          .setQuitDayReminderEnabled(true);

      expect(notifications.quitDates, [now.add(const Duration(days: 5))]);
      expect(
        SerenityNotificationIds.dailyCheckIn,
        isNot(SerenityNotificationIds.quitDay),
      );
    },
  );
}

class _FakeNotifications implements NotificationService {
  bool permissionGranted = true;
  bool initialized = false;
  int permissionRequests = 0;
  int dailyCancelCalls = 0;
  final dailyTimes = <ReminderTime>[];
  final quitDates = <DateTime>[];

  @override
  Future<void> cancelAll() async {}

  @override
  Future<void> cancelDailyCheckIn() async => dailyCancelCalls++;

  @override
  Future<void> cancelQuitDay() async {}

  @override
  Future<void> initialize() async => initialized = true;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<void> scheduleDailyCheckIn(ReminderTime time) async =>
      dailyTimes.add(time);

  @override
  Future<void> scheduleQuitDay(DateTime quitDate) async =>
      quitDates.add(quitDate);
}
