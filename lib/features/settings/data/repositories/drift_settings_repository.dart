import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/settings_preferences.dart';
import '../../domain/repositories/settings_repository.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._database);

  static const _themeKey = 'settings.theme_preference';
  static const _dailyEnabledKey = 'settings.daily_checkin_enabled';
  static const _dailyHourKey = 'settings.daily_checkin_hour';
  static const _dailyMinuteKey = 'settings.daily_checkin_minute';
  static const _quitEnabledKey = 'settings.quit_day_reminder_enabled';

  final db.AppDatabase _database;

  @override
  Future<SettingsPreferences> getPreferences() async =>
      _fromRows(await _database.select(_database.appMetadata).get());

  @override
  Stream<SettingsPreferences> watchPreferences() =>
      _database.select(_database.appMetadata).watch().map(_fromRows);

  @override
  Future<void> savePreferences(SettingsPreferences preferences) {
    return _database.transaction(() async {
      await _write(_themeKey, preferences.themePreference.name);
      await _write(
        _dailyEnabledKey,
        preferences.dailyCheckInEnabled.toString(),
      );
      await _write(_dailyHourKey, preferences.dailyCheckInTime.hour.toString());
      await _write(
        _dailyMinuteKey,
        preferences.dailyCheckInTime.minute.toString(),
      );
      await _write(
        _quitEnabledKey,
        preferences.quitDayReminderEnabled.toString(),
      );
    });
  }

  Future<void> _write(String key, String value) => _database
      .into(_database.appMetadata)
      .insertOnConflictUpdate(
        db.AppMetadataCompanion.insert(key: key, value: value),
      );

  SettingsPreferences _fromRows(List<db.AppMetadataData> rows) {
    final values = {for (final row in rows) row.key: row.value};
    final defaultTime = SettingsPreferences.defaults.dailyCheckInTime;
    return SettingsPreferences(
      themePreference:
          AppThemePreference.values
              .where((item) => item.name == values[_themeKey])
              .firstOrNull ??
          AppThemePreference.system,
      dailyCheckInEnabled: values[_dailyEnabledKey] == 'true',
      dailyCheckInTime: ReminderTime(
        hour: _validatedPart(values[_dailyHourKey], defaultTime.hour, 23),
        minute: _validatedPart(values[_dailyMinuteKey], defaultTime.minute, 59),
      ),
      quitDayReminderEnabled: values[_quitEnabledKey] == 'true',
    );
  }

  int _validatedPart(String? value, int fallback, int max) {
    final parsed = int.tryParse(value ?? '');
    return parsed == null || parsed < 0 || parsed > max ? fallback : parsed;
  }
}
