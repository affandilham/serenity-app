import '../entities/settings_preferences.dart';

abstract interface class SettingsRepository {
  Stream<SettingsPreferences> watchPreferences();

  Future<SettingsPreferences> getPreferences();

  Future<void> savePreferences(SettingsPreferences preferences);
}
