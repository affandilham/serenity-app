import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/settings/domain/entities/settings_preferences.dart';
import 'notification_service.dart';

class FlutterNotificationService implements NotificationService {
  FlutterNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    Future<TimezoneInfo> Function()? timezoneResolver,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _timezoneResolver = timezoneResolver ?? FlutterTimezone.getLocalTimezone;

  static const _channelId = 'serenity_reminders';
  static const _channelName = 'Pengingat Serenity';
  static const _channelDescription = 'Pengingat pribadi dari Serenity';

  final FlutterLocalNotificationsPlugin _plugin;
  final Future<TimezoneInfo> Function() _timezoneResolver;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    tz_data.initializeTimeZones();
    final timezone = await _timezoneResolver();
    tz.setLocalLocation(tz.getLocation(timezone.identifier));
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  @override
  Future<void> scheduleDailyCheckIn(ReminderTime time) async {
    await initialize();
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      SerenityNotificationIds.dailyCheckIn,
      'Check-in singkat',
      'Mau catat bagaimana harimu?',
      scheduled,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> scheduleQuitDay(DateTime quitDate) async {
    await initialize();
    final localDate = quitDate.toLocal();
    var scheduled = tz.TZDateTime(
      tz.local,
      localDate.year,
      localDate.month,
      localDate.day,
      8,
    );
    final now = tz.TZDateTime.now(tz.local);
    if (!scheduled.isAfter(now)) {
      await cancelQuitDay();
      return;
    }
    await _plugin.zonedSchedule(
      SerenityNotificationIds.quitDay,
      'Hari yang kamu pilih sudah tiba.',
      'Hari ini cukup fokus pada hari ini.',
      scheduled,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  NotificationDetails get _details => const NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
    iOS: DarwinNotificationDetails(),
  );

  @override
  Future<void> cancelDailyCheckIn() =>
      _plugin.cancel(SerenityNotificationIds.dailyCheckIn);

  @override
  Future<void> cancelQuitDay() =>
      _plugin.cancel(SerenityNotificationIds.quitDay);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();
}
