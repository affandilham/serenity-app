import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/goal_type.dart';
import '../../domain/entities/onboarding_draft.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final db.AppDatabase _database;
  final DateTime Function() _clock;

  @override
  Stream<UserProfile?> watchProfile() {
    final query = _database.select(_database.userProfiles)..limit(1);
    return query.watchSingleOrNull().map(_profileFromRow);
  }

  @override
  Future<UserProfile?> getProfile() async {
    final query = _database.select(_database.userProfiles)..limit(1);
    return _profileFromRow(await query.getSingleOrNull());
  }

  @override
  Future<List<PersonalMotivation>> getMotivations() async {
    final query = _database.select(_database.motivations)
      ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]);
    return (await query.get()).map(_motivationFromRow).toList();
  }

  @override
  Future<void> saveOnboarding(OnboardingDraft draft) async {
    if (!draft.canFinish) {
      throw ArgumentError(
        'A baseline and goal are required to finish onboarding.',
      );
    }

    final now = _clock();
    await _database.transaction(() async {
      await _database.delete(_database.userProfiles).go();
      await _database
          .into(_database.userProfiles)
          .insert(
            db.UserProfilesCompanion.insert(
              id: 'primary',
              createdAt: now,
              baselineCigarettesPerDay: draft.baselineCigarettesPerDay!,
              cigarettesPerPack: Value(draft.cigarettesPerPack),
              packPrice: Value(draft.packPrice),
              firstCigaretteAfterWakingMinutes: Value(
                draft.firstCigaretteAfterWakingMinutes,
              ),
              goalType: draft.goalType!.storageValue,
              onboardingCompleted: const Value(true),
            ),
          );

      final hasMotivation =
          draft.motivationCategory != null ||
          draft.motivationText.trim().isNotEmpty;
      if (hasMotivation) {
        await _database
            .into(_database.motivations)
            .insert(
              db.MotivationsCompanion.insert(
                id: 'onboarding-primary',
                content: draft.motivationText.trim().isEmpty
                    ? draft.motivationCategory!
                    : draft.motivationText.trim(),
                category: draft.motivationCategory ?? 'Lainnya',
                createdAt: now,
              ),
            );
      }
    });
  }

  @override
  Future<void> updatePattern({
    required int baselineCigarettesPerDay,
    required int? cigarettesPerPack,
    required int? packPrice,
  }) async {
    if (baselineCigarettesPerDay <= 0) {
      throw ArgumentError.value(
        baselineCigarettesPerDay,
        'baselineCigarettesPerDay',
        'The baseline must be greater than zero.',
      );
    }
    if (cigarettesPerPack != null && cigarettesPerPack <= 0) {
      throw ArgumentError.value(
        cigarettesPerPack,
        'cigarettesPerPack',
        'Cigarettes per pack must be greater than zero.',
      );
    }
    if (packPrice != null && packPrice < 0) {
      throw ArgumentError.value(
        packPrice,
        'packPrice',
        'The pack price cannot be negative.',
      );
    }
    final updated =
        await (_database.update(
          _database.userProfiles,
        )..where((table) => table.id.equals('primary'))).write(
          db.UserProfilesCompanion(
            baselineCigarettesPerDay: Value(baselineCigarettesPerDay),
            cigarettesPerPack: Value(cigarettesPerPack),
            packPrice: Value(packPrice),
          ),
        );
    if (updated == 0) {
      throw StateError('The profile could not be found.');
    }
  }

  UserProfile? _profileFromRow(db.UserProfile? row) {
    if (row == null) {
      return null;
    }
    return UserProfile(
      id: row.id,
      createdAt: row.createdAt,
      baselineCigarettesPerDay: row.baselineCigarettesPerDay,
      cigarettesPerPack: row.cigarettesPerPack,
      packPrice: row.packPrice,
      firstCigaretteAfterWakingMinutes: row.firstCigaretteAfterWakingMinutes,
      goalType: GoalType.fromStorage(row.goalType),
      onboardingCompleted: row.onboardingCompleted,
    );
  }

  PersonalMotivation _motivationFromRow(db.Motivation row) =>
      PersonalMotivation(
        id: row.id,
        text: row.content,
        category: row.category,
        showDuringCraving: row.showDuringCraving,
        sortOrder: row.sortOrder,
        createdAt: row.createdAt,
      );
}
