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
}
