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
    },
  );
}
