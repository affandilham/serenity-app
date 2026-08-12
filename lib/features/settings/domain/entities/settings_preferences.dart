import 'package:flutter/material.dart';

enum AppThemePreference {
  system,
  light,
  dark;

  ThemeMode get themeMode => switch (this) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
}

class ReminderTime {
  const ReminderTime({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  static const dailyDefault = ReminderTime(hour: 20, minute: 0);

  final int hour;
  final int minute;

  TimeOfDay get asTimeOfDay => TimeOfDay(hour: hour, minute: minute);

  String get label =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) =>
      other is ReminderTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);
}

class SettingsPreferences {
  const SettingsPreferences({
    required this.themePreference,
    required this.dailyCheckInEnabled,
    required this.dailyCheckInTime,
    required this.quitDayReminderEnabled,
  });

  static const defaults = SettingsPreferences(
    themePreference: AppThemePreference.system,
    dailyCheckInEnabled: false,
    dailyCheckInTime: ReminderTime.dailyDefault,
    quitDayReminderEnabled: false,
  );

  final AppThemePreference themePreference;
  final bool dailyCheckInEnabled;
  final ReminderTime dailyCheckInTime;
  final bool quitDayReminderEnabled;

  SettingsPreferences copyWith({
    AppThemePreference? themePreference,
    bool? dailyCheckInEnabled,
    ReminderTime? dailyCheckInTime,
    bool? quitDayReminderEnabled,
  }) => SettingsPreferences(
    themePreference: themePreference ?? this.themePreference,
    dailyCheckInEnabled: dailyCheckInEnabled ?? this.dailyCheckInEnabled,
    dailyCheckInTime: dailyCheckInTime ?? this.dailyCheckInTime,
    quitDayReminderEnabled:
        quitDayReminderEnabled ?? this.quitDayReminderEnabled,
  );
}
