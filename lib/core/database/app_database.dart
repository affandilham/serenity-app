import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class UserProfiles extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get baselineCigarettesPerDay => integer()();
  IntColumn get cigarettesPerPack => integer().nullable()();
  IntColumn get packPrice => integer().nullable()();
  IntColumn get firstCigaretteAfterWakingMinutes => integer().nullable()();
  TextColumn get goalType => text()();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Motivations extends Table {
  TextColumn get id => text()();
  TextColumn get content => text().named('text')();
  TextColumn get category => text()();
  BoolColumn get showDuringCraving =>
      boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [AppMetadata, UserProfiles, Motivations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'serenity'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(userProfiles);
        await migrator.createTable(motivations);
      }
    },
  );
}
