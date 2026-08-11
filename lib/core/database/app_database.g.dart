// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetadataTable extends AppMetadata
    with TableInfo<$AppMetadataTable, AppMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetadataTable createAlias(String alias) {
    return $AppMetadataTable(attachedDatabase, alias);
  }
}

class AppMetadataData extends DataClass implements Insertable<AppMetadataData> {
  final String key;
  final String value;
  const AppMetadataData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetadataCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetadataData copyWith({String? key, String? value}) =>
      AppMetadataData(key: key ?? this.key, value: value ?? this.value);
  AppMetadataData copyWithCompanion(AppMetadataCompanion data) {
    return AppMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetadataCompanion extends UpdateCompanion<AppMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baselineCigarettesPerDayMeta =
      const VerificationMeta('baselineCigarettesPerDay');
  @override
  late final GeneratedColumn<int> baselineCigarettesPerDay =
      GeneratedColumn<int>(
        'baseline_cigarettes_per_day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _cigarettesPerPackMeta = const VerificationMeta(
    'cigarettesPerPack',
  );
  @override
  late final GeneratedColumn<int> cigarettesPerPack = GeneratedColumn<int>(
    'cigarettes_per_pack',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _packPriceMeta = const VerificationMeta(
    'packPrice',
  );
  @override
  late final GeneratedColumn<int> packPrice = GeneratedColumn<int>(
    'pack_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstCigaretteAfterWakingMinutesMeta =
      const VerificationMeta('firstCigaretteAfterWakingMinutes');
  @override
  late final GeneratedColumn<int> firstCigaretteAfterWakingMinutes =
      GeneratedColumn<int>(
        'first_cigarette_after_waking_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    baselineCigarettesPerDay,
    cigarettesPerPack,
    packPrice,
    firstCigaretteAfterWakingMinutes,
    goalType,
    onboardingCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('baseline_cigarettes_per_day')) {
      context.handle(
        _baselineCigarettesPerDayMeta,
        baselineCigarettesPerDay.isAcceptableOrUnknown(
          data['baseline_cigarettes_per_day']!,
          _baselineCigarettesPerDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baselineCigarettesPerDayMeta);
    }
    if (data.containsKey('cigarettes_per_pack')) {
      context.handle(
        _cigarettesPerPackMeta,
        cigarettesPerPack.isAcceptableOrUnknown(
          data['cigarettes_per_pack']!,
          _cigarettesPerPackMeta,
        ),
      );
    }
    if (data.containsKey('pack_price')) {
      context.handle(
        _packPriceMeta,
        packPrice.isAcceptableOrUnknown(data['pack_price']!, _packPriceMeta),
      );
    }
    if (data.containsKey('first_cigarette_after_waking_minutes')) {
      context.handle(
        _firstCigaretteAfterWakingMinutesMeta,
        firstCigaretteAfterWakingMinutes.isAcceptableOrUnknown(
          data['first_cigarette_after_waking_minutes']!,
          _firstCigaretteAfterWakingMinutesMeta,
        ),
      );
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      baselineCigarettesPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baseline_cigarettes_per_day'],
      )!,
      cigarettesPerPack: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cigarettes_per_pack'],
      ),
      packPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_price'],
      ),
      firstCigaretteAfterWakingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_cigarette_after_waking_minutes'],
      ),
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final DateTime createdAt;
  final int baselineCigarettesPerDay;
  final int? cigarettesPerPack;
  final int? packPrice;
  final int? firstCigaretteAfterWakingMinutes;
  final String goalType;
  final bool onboardingCompleted;
  const UserProfile({
    required this.id,
    required this.createdAt,
    required this.baselineCigarettesPerDay,
    this.cigarettesPerPack,
    this.packPrice,
    this.firstCigaretteAfterWakingMinutes,
    required this.goalType,
    required this.onboardingCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['baseline_cigarettes_per_day'] = Variable<int>(
      baselineCigarettesPerDay,
    );
    if (!nullToAbsent || cigarettesPerPack != null) {
      map['cigarettes_per_pack'] = Variable<int>(cigarettesPerPack);
    }
    if (!nullToAbsent || packPrice != null) {
      map['pack_price'] = Variable<int>(packPrice);
    }
    if (!nullToAbsent || firstCigaretteAfterWakingMinutes != null) {
      map['first_cigarette_after_waking_minutes'] = Variable<int>(
        firstCigaretteAfterWakingMinutes,
      );
    }
    map['goal_type'] = Variable<String>(goalType);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      baselineCigarettesPerDay: Value(baselineCigarettesPerDay),
      cigarettesPerPack: cigarettesPerPack == null && nullToAbsent
          ? const Value.absent()
          : Value(cigarettesPerPack),
      packPrice: packPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(packPrice),
      firstCigaretteAfterWakingMinutes:
          firstCigaretteAfterWakingMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(firstCigaretteAfterWakingMinutes),
      goalType: Value(goalType),
      onboardingCompleted: Value(onboardingCompleted),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      baselineCigarettesPerDay: serializer.fromJson<int>(
        json['baselineCigarettesPerDay'],
      ),
      cigarettesPerPack: serializer.fromJson<int?>(json['cigarettesPerPack']),
      packPrice: serializer.fromJson<int?>(json['packPrice']),
      firstCigaretteAfterWakingMinutes: serializer.fromJson<int?>(
        json['firstCigaretteAfterWakingMinutes'],
      ),
      goalType: serializer.fromJson<String>(json['goalType']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'baselineCigarettesPerDay': serializer.toJson<int>(
        baselineCigarettesPerDay,
      ),
      'cigarettesPerPack': serializer.toJson<int?>(cigarettesPerPack),
      'packPrice': serializer.toJson<int?>(packPrice),
      'firstCigaretteAfterWakingMinutes': serializer.toJson<int?>(
        firstCigaretteAfterWakingMinutes,
      ),
      'goalType': serializer.toJson<String>(goalType),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
    };
  }

  UserProfile copyWith({
    String? id,
    DateTime? createdAt,
    int? baselineCigarettesPerDay,
    Value<int?> cigarettesPerPack = const Value.absent(),
    Value<int?> packPrice = const Value.absent(),
    Value<int?> firstCigaretteAfterWakingMinutes = const Value.absent(),
    String? goalType,
    bool? onboardingCompleted,
  }) => UserProfile(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    baselineCigarettesPerDay:
        baselineCigarettesPerDay ?? this.baselineCigarettesPerDay,
    cigarettesPerPack: cigarettesPerPack.present
        ? cigarettesPerPack.value
        : this.cigarettesPerPack,
    packPrice: packPrice.present ? packPrice.value : this.packPrice,
    firstCigaretteAfterWakingMinutes: firstCigaretteAfterWakingMinutes.present
        ? firstCigaretteAfterWakingMinutes.value
        : this.firstCigaretteAfterWakingMinutes,
    goalType: goalType ?? this.goalType,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      baselineCigarettesPerDay: data.baselineCigarettesPerDay.present
          ? data.baselineCigarettesPerDay.value
          : this.baselineCigarettesPerDay,
      cigarettesPerPack: data.cigarettesPerPack.present
          ? data.cigarettesPerPack.value
          : this.cigarettesPerPack,
      packPrice: data.packPrice.present ? data.packPrice.value : this.packPrice,
      firstCigaretteAfterWakingMinutes:
          data.firstCigaretteAfterWakingMinutes.present
          ? data.firstCigaretteAfterWakingMinutes.value
          : this.firstCigaretteAfterWakingMinutes,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('baselineCigarettesPerDay: $baselineCigarettesPerDay, ')
          ..write('cigarettesPerPack: $cigarettesPerPack, ')
          ..write('packPrice: $packPrice, ')
          ..write(
            'firstCigaretteAfterWakingMinutes: $firstCigaretteAfterWakingMinutes, ',
          )
          ..write('goalType: $goalType, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    baselineCigarettesPerDay,
    cigarettesPerPack,
    packPrice,
    firstCigaretteAfterWakingMinutes,
    goalType,
    onboardingCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.baselineCigarettesPerDay == this.baselineCigarettesPerDay &&
          other.cigarettesPerPack == this.cigarettesPerPack &&
          other.packPrice == this.packPrice &&
          other.firstCigaretteAfterWakingMinutes ==
              this.firstCigaretteAfterWakingMinutes &&
          other.goalType == this.goalType &&
          other.onboardingCompleted == this.onboardingCompleted);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<int> baselineCigarettesPerDay;
  final Value<int?> cigarettesPerPack;
  final Value<int?> packPrice;
  final Value<int?> firstCigaretteAfterWakingMinutes;
  final Value<String> goalType;
  final Value<bool> onboardingCompleted;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.baselineCigarettesPerDay = const Value.absent(),
    this.cigarettesPerPack = const Value.absent(),
    this.packPrice = const Value.absent(),
    this.firstCigaretteAfterWakingMinutes = const Value.absent(),
    this.goalType = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required int baselineCigarettesPerDay,
    this.cigarettesPerPack = const Value.absent(),
    this.packPrice = const Value.absent(),
    this.firstCigaretteAfterWakingMinutes = const Value.absent(),
    required String goalType,
    this.onboardingCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       baselineCigarettesPerDay = Value(baselineCigarettesPerDay),
       goalType = Value(goalType);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<int>? baselineCigarettesPerDay,
    Expression<int>? cigarettesPerPack,
    Expression<int>? packPrice,
    Expression<int>? firstCigaretteAfterWakingMinutes,
    Expression<String>? goalType,
    Expression<bool>? onboardingCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (baselineCigarettesPerDay != null)
        'baseline_cigarettes_per_day': baselineCigarettesPerDay,
      if (cigarettesPerPack != null) 'cigarettes_per_pack': cigarettesPerPack,
      if (packPrice != null) 'pack_price': packPrice,
      if (firstCigaretteAfterWakingMinutes != null)
        'first_cigarette_after_waking_minutes':
            firstCigaretteAfterWakingMinutes,
      if (goalType != null) 'goal_type': goalType,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<int>? baselineCigarettesPerDay,
    Value<int?>? cigarettesPerPack,
    Value<int?>? packPrice,
    Value<int?>? firstCigaretteAfterWakingMinutes,
    Value<String>? goalType,
    Value<bool>? onboardingCompleted,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      baselineCigarettesPerDay:
          baselineCigarettesPerDay ?? this.baselineCigarettesPerDay,
      cigarettesPerPack: cigarettesPerPack ?? this.cigarettesPerPack,
      packPrice: packPrice ?? this.packPrice,
      firstCigaretteAfterWakingMinutes:
          firstCigaretteAfterWakingMinutes ??
          this.firstCigaretteAfterWakingMinutes,
      goalType: goalType ?? this.goalType,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (baselineCigarettesPerDay.present) {
      map['baseline_cigarettes_per_day'] = Variable<int>(
        baselineCigarettesPerDay.value,
      );
    }
    if (cigarettesPerPack.present) {
      map['cigarettes_per_pack'] = Variable<int>(cigarettesPerPack.value);
    }
    if (packPrice.present) {
      map['pack_price'] = Variable<int>(packPrice.value);
    }
    if (firstCigaretteAfterWakingMinutes.present) {
      map['first_cigarette_after_waking_minutes'] = Variable<int>(
        firstCigaretteAfterWakingMinutes.value,
      );
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('baselineCigarettesPerDay: $baselineCigarettesPerDay, ')
          ..write('cigarettesPerPack: $cigarettesPerPack, ')
          ..write('packPrice: $packPrice, ')
          ..write(
            'firstCigaretteAfterWakingMinutes: $firstCigaretteAfterWakingMinutes, ',
          )
          ..write('goalType: $goalType, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MotivationsTable extends Motivations
    with TableInfo<$MotivationsTable, Motivation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotivationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _showDuringCravingMeta = const VerificationMeta(
    'showDuringCraving',
  );
  @override
  late final GeneratedColumn<bool> showDuringCraving = GeneratedColumn<bool>(
    'show_during_craving',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_during_craving" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    category,
    showDuringCraving,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motivations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Motivation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['text']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('show_during_craving')) {
      context.handle(
        _showDuringCravingMeta,
        showDuringCraving.isAcceptableOrUnknown(
          data['show_during_craving']!,
          _showDuringCravingMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Motivation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Motivation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      showDuringCraving: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_during_craving'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MotivationsTable createAlias(String alias) {
    return $MotivationsTable(attachedDatabase, alias);
  }
}

class Motivation extends DataClass implements Insertable<Motivation> {
  final String id;
  final String content;
  final String category;
  final bool showDuringCraving;
  final int sortOrder;
  final DateTime createdAt;
  const Motivation({
    required this.id,
    required this.content,
    required this.category,
    required this.showDuringCraving,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['text'] = Variable<String>(content);
    map['category'] = Variable<String>(category);
    map['show_during_craving'] = Variable<bool>(showDuringCraving);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MotivationsCompanion toCompanion(bool nullToAbsent) {
    return MotivationsCompanion(
      id: Value(id),
      content: Value(content),
      category: Value(category),
      showDuringCraving: Value(showDuringCraving),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Motivation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Motivation(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String>(json['category']),
      showDuringCraving: serializer.fromJson<bool>(json['showDuringCraving']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String>(category),
      'showDuringCraving': serializer.toJson<bool>(showDuringCraving),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Motivation copyWith({
    String? id,
    String? content,
    String? category,
    bool? showDuringCraving,
    int? sortOrder,
    DateTime? createdAt,
  }) => Motivation(
    id: id ?? this.id,
    content: content ?? this.content,
    category: category ?? this.category,
    showDuringCraving: showDuringCraving ?? this.showDuringCraving,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Motivation copyWithCompanion(MotivationsCompanion data) {
    return Motivation(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      showDuringCraving: data.showDuringCraving.present
          ? data.showDuringCraving.value
          : this.showDuringCraving,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Motivation(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('showDuringCraving: $showDuringCraving, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    category,
    showDuringCraving,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Motivation &&
          other.id == this.id &&
          other.content == this.content &&
          other.category == this.category &&
          other.showDuringCraving == this.showDuringCraving &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class MotivationsCompanion extends UpdateCompanion<Motivation> {
  final Value<String> id;
  final Value<String> content;
  final Value<String> category;
  final Value<bool> showDuringCraving;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MotivationsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.showDuringCraving = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MotivationsCompanion.insert({
    required String id,
    required String content,
    required String category,
    this.showDuringCraving = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<Motivation> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? category,
    Expression<bool>? showDuringCraving,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'text': content,
      if (category != null) 'category': category,
      if (showDuringCraving != null) 'show_during_craving': showDuringCraving,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MotivationsCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String>? category,
    Value<bool>? showDuringCraving,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MotivationsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      category: category ?? this.category,
      showDuringCraving: showDuringCraving ?? this.showDuringCraving,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (showDuringCraving.present) {
      map['show_during_craving'] = Variable<bool>(showDuringCraving.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotivationsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('showDuringCraving: $showDuringCraving, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $MotivationsTable motivations = $MotivationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadata,
    userProfiles,
    motivations,
  ];
}

typedef $$AppMetadataTableCreateCompanionBuilder =
    AppMetadataCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetadataTableUpdateCompanionBuilder =
    AppMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTable,
          AppMetadataData,
          $$AppMetadataTableFilterComposer,
          $$AppMetadataTableOrderingComposer,
          $$AppMetadataTableAnnotationComposer,
          $$AppMetadataTableCreateCompanionBuilder,
          $$AppMetadataTableUpdateCompanionBuilder,
          (
            AppMetadataData,
            BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
          ),
          AppMetadataData,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableManager(_$AppDatabase db, $AppMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTable,
      AppMetadataData,
      $$AppMetadataTableFilterComposer,
      $$AppMetadataTableOrderingComposer,
      $$AppMetadataTableAnnotationComposer,
      $$AppMetadataTableCreateCompanionBuilder,
      $$AppMetadataTableUpdateCompanionBuilder,
      (
        AppMetadataData,
        BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
      ),
      AppMetadataData,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      required DateTime createdAt,
      required int baselineCigarettesPerDay,
      Value<int?> cigarettesPerPack,
      Value<int?> packPrice,
      Value<int?> firstCigaretteAfterWakingMinutes,
      required String goalType,
      Value<bool> onboardingCompleted,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<int> baselineCigarettesPerDay,
      Value<int?> cigarettesPerPack,
      Value<int?> packPrice,
      Value<int?> firstCigaretteAfterWakingMinutes,
      Value<String> goalType,
      Value<bool> onboardingCompleted,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baselineCigarettesPerDay => $composableBuilder(
    column: $table.baselineCigarettesPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cigarettesPerPack => $composableBuilder(
    column: $table.cigarettesPerPack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packPrice => $composableBuilder(
    column: $table.packPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstCigaretteAfterWakingMinutes => $composableBuilder(
    column: $table.firstCigaretteAfterWakingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baselineCigarettesPerDay => $composableBuilder(
    column: $table.baselineCigarettesPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cigarettesPerPack => $composableBuilder(
    column: $table.cigarettesPerPack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packPrice => $composableBuilder(
    column: $table.packPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstCigaretteAfterWakingMinutes =>
      $composableBuilder(
        column: $table.firstCigaretteAfterWakingMinutes,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get baselineCigarettesPerDay => $composableBuilder(
    column: $table.baselineCigarettesPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cigarettesPerPack => $composableBuilder(
    column: $table.cigarettesPerPack,
    builder: (column) => column,
  );

  GeneratedColumn<int> get packPrice =>
      $composableBuilder(column: $table.packPrice, builder: (column) => column);

  GeneratedColumn<int> get firstCigaretteAfterWakingMinutes =>
      $composableBuilder(
        column: $table.firstCigaretteAfterWakingMinutes,
        builder: (column) => column,
      );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> baselineCigarettesPerDay = const Value.absent(),
                Value<int?> cigarettesPerPack = const Value.absent(),
                Value<int?> packPrice = const Value.absent(),
                Value<int?> firstCigaretteAfterWakingMinutes =
                    const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                createdAt: createdAt,
                baselineCigarettesPerDay: baselineCigarettesPerDay,
                cigarettesPerPack: cigarettesPerPack,
                packPrice: packPrice,
                firstCigaretteAfterWakingMinutes:
                    firstCigaretteAfterWakingMinutes,
                goalType: goalType,
                onboardingCompleted: onboardingCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required int baselineCigarettesPerDay,
                Value<int?> cigarettesPerPack = const Value.absent(),
                Value<int?> packPrice = const Value.absent(),
                Value<int?> firstCigaretteAfterWakingMinutes =
                    const Value.absent(),
                required String goalType,
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                createdAt: createdAt,
                baselineCigarettesPerDay: baselineCigarettesPerDay,
                cigarettesPerPack: cigarettesPerPack,
                packPrice: packPrice,
                firstCigaretteAfterWakingMinutes:
                    firstCigaretteAfterWakingMinutes,
                goalType: goalType,
                onboardingCompleted: onboardingCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$MotivationsTableCreateCompanionBuilder =
    MotivationsCompanion Function({
      required String id,
      required String content,
      required String category,
      Value<bool> showDuringCraving,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MotivationsTableUpdateCompanionBuilder =
    MotivationsCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String> category,
      Value<bool> showDuringCraving,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MotivationsTableFilterComposer
    extends Composer<_$AppDatabase, $MotivationsTable> {
  $$MotivationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showDuringCraving => $composableBuilder(
    column: $table.showDuringCraving,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MotivationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MotivationsTable> {
  $$MotivationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showDuringCraving => $composableBuilder(
    column: $table.showDuringCraving,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MotivationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotivationsTable> {
  $$MotivationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get showDuringCraving => $composableBuilder(
    column: $table.showDuringCraving,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MotivationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MotivationsTable,
          Motivation,
          $$MotivationsTableFilterComposer,
          $$MotivationsTableOrderingComposer,
          $$MotivationsTableAnnotationComposer,
          $$MotivationsTableCreateCompanionBuilder,
          $$MotivationsTableUpdateCompanionBuilder,
          (
            Motivation,
            BaseReferences<_$AppDatabase, $MotivationsTable, Motivation>,
          ),
          Motivation,
          PrefetchHooks Function()
        > {
  $$MotivationsTableTableManager(_$AppDatabase db, $MotivationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotivationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotivationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotivationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> showDuringCraving = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MotivationsCompanion(
                id: id,
                content: content,
                category: category,
                showDuringCraving: showDuringCraving,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                required String category,
                Value<bool> showDuringCraving = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MotivationsCompanion.insert(
                id: id,
                content: content,
                category: category,
                showDuringCraving: showDuringCraving,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MotivationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MotivationsTable,
      Motivation,
      $$MotivationsTableFilterComposer,
      $$MotivationsTableOrderingComposer,
      $$MotivationsTableAnnotationComposer,
      $$MotivationsTableCreateCompanionBuilder,
      $$MotivationsTableUpdateCompanionBuilder,
      (
        Motivation,
        BaseReferences<_$AppDatabase, $MotivationsTable, Motivation>,
      ),
      Motivation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetadataTableTableManager get appMetadata =>
      $$AppMetadataTableTableManager(_db, _db.appMetadata);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$MotivationsTableTableManager get motivations =>
      $$MotivationsTableTableManager(_db, _db.motivations);
}
