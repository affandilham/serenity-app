import 'dart:convert';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/notifications/notification_service.dart';
import 'package:serenity_app/features/settings/domain/entities/settings_preferences.dart';
import 'package:serenity_app/features/settings/domain/services/reset_service.dart';
import 'package:serenity_app/features/settings/domain/services/serenity_export_service.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('exports a structured, relational JSON snapshot', () async {
    final now = DateTime.utc(2026, 8, 12, 9);
    await database
        .into(database.userProfiles)
        .insert(
          UserProfilesCompanion.insert(
            id: 'primary',
            createdAt: now,
            baselineCigarettesPerDay: 8,
            cigarettesPerPack: const Value(16),
            packPrice: const Value(30000),
            goalType: 'quit',
            onboardingCompleted: const Value(true),
          ),
        );
    await database
        .into(database.motivations)
        .insert(
          MotivationsCompanion.insert(
            id: 'why',
            content: 'Keluarga',
            category: 'Keluarga',
            createdAt: now,
          ),
        );
    await database
        .into(database.triggers)
        .insert(
          TriggersCompanion.insert(
            id: 'coffee',
            name: 'Kopi',
            isDefault: const Value(true),
            createdAt: now,
          ),
        );
    await database
        .into(database.smokingLogs)
        .insert(
          SmokingLogsCompanion.insert(id: 'log', smokedAt: now, createdAt: now),
        );
    await database
        .into(database.smokingLogTriggers)
        .insert(
          const SmokingLogTriggersCompanion(
            smokingLogId: Value('log'),
            triggerId: Value('coffee'),
          ),
        );
    await database
        .into(database.quitPlans)
        .insert(
          QuitPlansCompanion.insert(
            id: 'plan',
            quitDate: now.add(const Duration(days: 3)),
            primaryMotivationId: const Value('why'),
            status: 'draft',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.quitPlanStrategies)
        .insert(
          QuitPlanStrategiesCompanion.insert(
            id: 'strategy',
            quitPlanId: 'plan',
            triggerId: const Value('coffee'),
            action: 'Minum air',
            createdAt: now,
          ),
        );

    final json = await SerenityExportService(
      database,
      clock: () => now,
    ).buildJson();
    final export = jsonDecode(json) as Map<String, dynamic>;

    expect(export['exportVersion'], 1);
    expect(export['app'], 'Serenity');
    expect(export['profile']['baselineCigarettesPerDay'], 8);
    expect(export['smokingLogs'].single['triggerIds'], ['coffee']);
    expect(
      export['quitPlans'].single['strategies'].single['triggerId'],
      'coffee',
    );
    expect(export['motivations'].single['id'], 'why');
  });

  test('exports valid JSON for an empty installation', () async {
    final json = await SerenityExportService(database).buildJson();
    final export = jsonDecode(json) as Map<String, dynamic>;

    expect(export['profile'], isNull);
    expect(export['smokingLogs'], isEmpty);
    expect(export['quitPlans'], isEmpty);
  });

  test(
    'delete all clears behavioral data, preferences, and notifications',
    () async {
      final now = DateTime.utc(2026, 8, 12);
      await database
          .into(database.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              id: 'primary',
              createdAt: now,
              baselineCigarettesPerDay: 5,
              goalType: 'reduce',
            ),
          );
      await database
          .into(database.smokingLogs)
          .insert(
            SmokingLogsCompanion.insert(
              id: 'log',
              smokedAt: now,
              createdAt: now,
            ),
          );
      await database
          .into(database.appMetadata)
          .insert(
            AppMetadataCompanion.insert(
              key: 'settings.theme_preference',
              value: 'dark',
            ),
          );
      final notifications = _FakeNotifications();

      await ResetService(database, notifications).deleteAllPersonalData();

      expect(notifications.cancelAllCalls, 1);
      expect(await database.select(database.userProfiles).get(), isEmpty);
      expect(await database.select(database.smokingLogs).get(), isEmpty);
      expect(await database.select(database.appMetadata).get(), isEmpty);
    },
  );
}

class _FakeNotifications implements NotificationService {
  int cancelAllCalls = 0;

  @override
  Future<void> cancelAll() async => cancelAllCalls++;

  @override
  Future<void> cancelDailyCheckIn() async {}

  @override
  Future<void> cancelQuitDay() async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleDailyCheckIn(ReminderTime time) async {}

  @override
  Future<void> scheduleQuitDay(DateTime quitDate) async {}
}
