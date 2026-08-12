import '../../features/settings/domain/entities/settings_preferences.dart';

abstract interface class NotificationService {
  Future<void> initialize();

  Future<bool> requestPermission();

  Future<void> scheduleDailyCheckIn(ReminderTime time);

  Future<void> scheduleQuitDay(DateTime quitDate);

  Future<void> cancelDailyCheckIn();

  Future<void> cancelQuitDay();

  Future<void> cancelAll();
}

abstract final class SerenityNotificationIds {
  static const dailyCheckIn = 7101;
  static const quitDay = 7102;
}
