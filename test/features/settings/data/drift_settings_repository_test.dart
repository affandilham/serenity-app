import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:serenity_app/features/settings/domain/entities/settings_preferences.dart';

void main() {
  late AppDatabase database;
  late DriftSettingsRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftSettingsRepository(database);
  });

  tearDown(() => database.close());

  test(
    'defaults notifications to off and persists theme and reminder choices',
    () async {
      expect(await repository.getPreferences(), isA<SettingsPreferences>());
      expect((await repository.getPreferences()).dailyCheckInEnabled, isFalse);
      expect(
        (await repository.getPreferences()).quitDayReminderEnabled,
        isFalse,
      );

      const preferences = SettingsPreferences(
        themePreference: AppThemePreference.dark,
        dailyCheckInEnabled: true,
        dailyCheckInTime: ReminderTime(hour: 21, minute: 15),
        quitDayReminderEnabled: true,
      );
      await repository.savePreferences(preferences);

      expect(await repository.getPreferences(), isNotNull);
      final restored = await repository.getPreferences();
      expect(restored.themePreference, AppThemePreference.dark);
      expect(restored.dailyCheckInEnabled, isTrue);
      expect(
        restored.dailyCheckInTime,
        const ReminderTime(hour: 21, minute: 15),
      );
      expect(restored.quitDayReminderEnabled, isTrue);
    },
  );
}
