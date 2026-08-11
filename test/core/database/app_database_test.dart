import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('persists foundation metadata locally', () async {
    await database
        .into(database.appMetadata)
        .insert(AppMetadataCompanion.insert(key: 'foundation', value: 'ready'));

    final stored = await database.select(database.appMetadata).getSingle();

    expect(stored.key, 'foundation');
    expect(stored.value, 'ready');
  });

  test(
    'migrates the version 1 foundation schema without removing metadata',
    () async {
      await database.close();
      database = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (rawDatabase) {
            rawDatabase.execute(
              'CREATE TABLE app_metadata (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
            );
            rawDatabase.execute(
              "INSERT INTO app_metadata (key, value) VALUES ('foundation', 'ready')",
            );
            rawDatabase.execute('PRAGMA user_version = 1');
          },
        ),
      );

      final metadata = await database.select(database.appMetadata).getSingle();
      await database
          .into(database.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              id: 'primary',
              createdAt: DateTime.utc(2026, 8, 11),
              baselineCigarettesPerDay: 8,
              goalType: 'reduce',
            ),
          );

      expect(metadata.value, 'ready');
      expect(await database.select(database.userProfiles).get(), hasLength(1));
      await database
          .into(database.smokingLogs)
          .insert(
            SmokingLogsCompanion.insert(
              id: 'log-1',
              smokedAt: DateTime.utc(2026, 8, 11, 9),
              createdAt: DateTime.utc(2026, 8, 11, 9),
            ),
          );
      expect(await database.select(database.smokingLogs).get(), hasLength(1));
    },
  );

  test(
    'migrates version 2 profile data before adding smoking-log tables',
    () async {
      await database.close();
      database = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (rawDatabase) {
            rawDatabase.execute(
              'CREATE TABLE app_metadata (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
            );
            rawDatabase.execute(
              'CREATE TABLE user_profiles ('
              'id TEXT NOT NULL PRIMARY KEY, '
              'created_at INTEGER NOT NULL, '
              'baseline_cigarettes_per_day INTEGER NOT NULL, '
              'cigarettes_per_pack INTEGER, '
              'pack_price INTEGER, '
              'first_cigarette_after_waking_minutes INTEGER, '
              'goal_type TEXT NOT NULL, '
              'onboarding_completed INTEGER NOT NULL DEFAULT 0'
              ')',
            );
            rawDatabase.execute(
              'CREATE TABLE motivations ('
              'id TEXT NOT NULL PRIMARY KEY, '
              'text TEXT NOT NULL, '
              'category TEXT NOT NULL, '
              'show_during_craving INTEGER NOT NULL DEFAULT 0, '
              'sort_order INTEGER NOT NULL DEFAULT 0, '
              'created_at INTEGER NOT NULL'
              ')',
            );
            rawDatabase.execute(
              "INSERT INTO user_profiles (id, created_at, baseline_cigarettes_per_day, goal_type, onboarding_completed) VALUES ('primary', 0, 8, 'reduce', 1)",
            );
            rawDatabase.execute('PRAGMA user_version = 2');
          },
        ),
      );

      final profile = await database.select(database.userProfiles).getSingle();

      expect(profile.baselineCigarettesPerDay, 8);
      expect(profile.goalType, 'reduce');
      expect(profile.onboardingCompleted, isTrue);
      expect(await database.select(database.smokingLogs).get(), isEmpty);
      expect(await database.select(database.triggers).get(), isEmpty);
    },
  );

  test('migrates version 3 smoking data before adding craving sessions', () async {
    await database.close();
    database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDatabase) {
          rawDatabase.execute(
            'CREATE TABLE app_metadata (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
          );
          rawDatabase.execute(
            'CREATE TABLE user_profiles ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'created_at INTEGER NOT NULL, '
            'baseline_cigarettes_per_day INTEGER NOT NULL, '
            'cigarettes_per_pack INTEGER, '
            'pack_price INTEGER, '
            'first_cigarette_after_waking_minutes INTEGER, '
            'goal_type TEXT NOT NULL, '
            'onboarding_completed INTEGER NOT NULL DEFAULT 0'
            ')',
          );
          rawDatabase.execute(
            'CREATE TABLE motivations ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'text TEXT NOT NULL, '
            'category TEXT NOT NULL, '
            'show_during_craving INTEGER NOT NULL DEFAULT 0, '
            'sort_order INTEGER NOT NULL DEFAULT 0, '
            'created_at INTEGER NOT NULL'
            ')',
          );
          rawDatabase.execute(
            'CREATE TABLE smoking_logs ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'smoked_at INTEGER NOT NULL, '
            'craving_level INTEGER, '
            'note TEXT, '
            'created_at INTEGER NOT NULL'
            ')',
          );
          rawDatabase.execute(
            'CREATE TABLE triggers ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'name TEXT NOT NULL, '
            'is_default INTEGER NOT NULL DEFAULT 0, '
            'created_at INTEGER NOT NULL'
            ')',
          );
          rawDatabase.execute(
            'CREATE TABLE smoking_log_triggers ('
            'smoking_log_id TEXT NOT NULL, '
            'trigger_id TEXT NOT NULL, '
            'PRIMARY KEY (smoking_log_id, trigger_id)'
            ')',
          );
          rawDatabase.execute(
            "INSERT INTO smoking_logs (id, smoked_at, created_at) VALUES ('log-1', 0, 0)",
          );
          rawDatabase.execute('PRAGMA user_version = 3');
        },
      ),
    );

    expect(await database.select(database.smokingLogs).get(), hasLength(1));
    expect(await database.select(database.cravingSessions).get(), isEmpty);
  });

  test('migrates version 4 data before adding quit-plan tables', () async {
    await database.close();
    database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDatabase) {
          rawDatabase.execute(
            'CREATE TABLE app_metadata (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
          );
          rawDatabase.execute(
            'CREATE TABLE user_profiles (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, baseline_cigarettes_per_day INTEGER NOT NULL, cigarettes_per_pack INTEGER, pack_price INTEGER, first_cigarette_after_waking_minutes INTEGER, goal_type TEXT NOT NULL, onboarding_completed INTEGER NOT NULL DEFAULT 0)',
          );
          rawDatabase.execute(
            'CREATE TABLE motivations (id TEXT NOT NULL PRIMARY KEY, text TEXT NOT NULL, category TEXT NOT NULL, show_during_craving INTEGER NOT NULL DEFAULT 0, sort_order INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL)',
          );
          rawDatabase.execute(
            'CREATE TABLE smoking_logs (id TEXT NOT NULL PRIMARY KEY, smoked_at INTEGER NOT NULL, craving_level INTEGER, note TEXT, created_at INTEGER NOT NULL)',
          );
          rawDatabase.execute(
            'CREATE TABLE triggers (id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL, is_default INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL)',
          );
          rawDatabase.execute(
            'CREATE TABLE smoking_log_triggers (smoking_log_id TEXT NOT NULL, trigger_id TEXT NOT NULL, PRIMARY KEY (smoking_log_id, trigger_id))',
          );
          rawDatabase.execute(
            'CREATE TABLE craving_sessions (id TEXT NOT NULL PRIMARY KEY, started_at INTEGER NOT NULL, ended_at INTEGER, initial_intensity INTEGER NOT NULL, final_intensity INTEGER, outcome TEXT, note TEXT)',
          );
          rawDatabase.execute(
            "INSERT INTO smoking_logs (id, smoked_at, created_at) VALUES ('log-1', 0, 0)",
          );
          rawDatabase.execute(
            "INSERT INTO craving_sessions (id, started_at, initial_intensity) VALUES ('craving-1', 0, 3)",
          );
          rawDatabase.execute('PRAGMA user_version = 4');
        },
      ),
    );

    expect(await database.select(database.smokingLogs).get(), hasLength(1));
    expect(await database.select(database.cravingSessions).get(), hasLength(1));
    expect(await database.select(database.quitPlans).get(), isEmpty);
    expect(await database.select(database.quitPlanStrategies).get(), isEmpty);
  });
}
