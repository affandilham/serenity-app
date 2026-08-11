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

class $SmokingLogsTable extends SmokingLogs
    with TableInfo<$SmokingLogsTable, SmokingLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmokingLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smokedAtMeta = const VerificationMeta(
    'smokedAt',
  );
  @override
  late final GeneratedColumn<DateTime> smokedAt = GeneratedColumn<DateTime>(
    'smoked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cravingLevelMeta = const VerificationMeta(
    'cravingLevel',
  );
  @override
  late final GeneratedColumn<int> cravingLevel = GeneratedColumn<int>(
    'craving_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    smokedAt,
    cravingLevel,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smoking_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmokingLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('smoked_at')) {
      context.handle(
        _smokedAtMeta,
        smokedAt.isAcceptableOrUnknown(data['smoked_at']!, _smokedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_smokedAtMeta);
    }
    if (data.containsKey('craving_level')) {
      context.handle(
        _cravingLevelMeta,
        cravingLevel.isAcceptableOrUnknown(
          data['craving_level']!,
          _cravingLevelMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
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
  SmokingLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmokingLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      smokedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}smoked_at'],
      )!,
      cravingLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}craving_level'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SmokingLogsTable createAlias(String alias) {
    return $SmokingLogsTable(attachedDatabase, alias);
  }
}

class SmokingLog extends DataClass implements Insertable<SmokingLog> {
  final String id;
  final DateTime smokedAt;
  final int? cravingLevel;
  final String? note;
  final DateTime createdAt;
  const SmokingLog({
    required this.id,
    required this.smokedAt,
    this.cravingLevel,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['smoked_at'] = Variable<DateTime>(smokedAt);
    if (!nullToAbsent || cravingLevel != null) {
      map['craving_level'] = Variable<int>(cravingLevel);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SmokingLogsCompanion toCompanion(bool nullToAbsent) {
    return SmokingLogsCompanion(
      id: Value(id),
      smokedAt: Value(smokedAt),
      cravingLevel: cravingLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(cravingLevel),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory SmokingLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmokingLog(
      id: serializer.fromJson<String>(json['id']),
      smokedAt: serializer.fromJson<DateTime>(json['smokedAt']),
      cravingLevel: serializer.fromJson<int?>(json['cravingLevel']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'smokedAt': serializer.toJson<DateTime>(smokedAt),
      'cravingLevel': serializer.toJson<int?>(cravingLevel),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SmokingLog copyWith({
    String? id,
    DateTime? smokedAt,
    Value<int?> cravingLevel = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => SmokingLog(
    id: id ?? this.id,
    smokedAt: smokedAt ?? this.smokedAt,
    cravingLevel: cravingLevel.present ? cravingLevel.value : this.cravingLevel,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  SmokingLog copyWithCompanion(SmokingLogsCompanion data) {
    return SmokingLog(
      id: data.id.present ? data.id.value : this.id,
      smokedAt: data.smokedAt.present ? data.smokedAt.value : this.smokedAt,
      cravingLevel: data.cravingLevel.present
          ? data.cravingLevel.value
          : this.cravingLevel,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmokingLog(')
          ..write('id: $id, ')
          ..write('smokedAt: $smokedAt, ')
          ..write('cravingLevel: $cravingLevel, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, smokedAt, cravingLevel, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmokingLog &&
          other.id == this.id &&
          other.smokedAt == this.smokedAt &&
          other.cravingLevel == this.cravingLevel &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class SmokingLogsCompanion extends UpdateCompanion<SmokingLog> {
  final Value<String> id;
  final Value<DateTime> smokedAt;
  final Value<int?> cravingLevel;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SmokingLogsCompanion({
    this.id = const Value.absent(),
    this.smokedAt = const Value.absent(),
    this.cravingLevel = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmokingLogsCompanion.insert({
    required String id,
    required DateTime smokedAt,
    this.cravingLevel = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       smokedAt = Value(smokedAt),
       createdAt = Value(createdAt);
  static Insertable<SmokingLog> custom({
    Expression<String>? id,
    Expression<DateTime>? smokedAt,
    Expression<int>? cravingLevel,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (smokedAt != null) 'smoked_at': smokedAt,
      if (cravingLevel != null) 'craving_level': cravingLevel,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmokingLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? smokedAt,
    Value<int?>? cravingLevel,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SmokingLogsCompanion(
      id: id ?? this.id,
      smokedAt: smokedAt ?? this.smokedAt,
      cravingLevel: cravingLevel ?? this.cravingLevel,
      note: note ?? this.note,
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
    if (smokedAt.present) {
      map['smoked_at'] = Variable<DateTime>(smokedAt.value);
    }
    if (cravingLevel.present) {
      map['craving_level'] = Variable<int>(cravingLevel.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
    return (StringBuffer('SmokingLogsCompanion(')
          ..write('id: $id, ')
          ..write('smokedAt: $smokedAt, ')
          ..write('cravingLevel: $cravingLevel, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TriggersTable extends Triggers with TableInfo<$TriggersTable, Trigger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriggersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  List<GeneratedColumn> get $columns => [id, name, isDefault, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'triggers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trigger> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
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
  Trigger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trigger(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TriggersTable createAlias(String alias) {
    return $TriggersTable(attachedDatabase, alias);
  }
}

class Trigger extends DataClass implements Insertable<Trigger> {
  final String id;
  final String name;
  final bool isDefault;
  final DateTime createdAt;
  const Trigger({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TriggersCompanion toCompanion(bool nullToAbsent) {
    return TriggersCompanion(
      id: Value(id),
      name: Value(name),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory Trigger.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trigger(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Trigger copyWith({
    String? id,
    String? name,
    bool? isDefault,
    DateTime? createdAt,
  }) => Trigger(
    id: id ?? this.id,
    name: name ?? this.name,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  Trigger copyWithCompanion(TriggersCompanion data) {
    return Trigger(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trigger(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDefault, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trigger &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class TriggersCompanion extends UpdateCompanion<Trigger> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TriggersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TriggersCompanion.insert({
    required String id,
    required String name,
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Trigger> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TriggersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TriggersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
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
    return (StringBuffer('TriggersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmokingLogTriggersTable extends SmokingLogTriggers
    with TableInfo<$SmokingLogTriggersTable, SmokingLogTrigger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmokingLogTriggersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _smokingLogIdMeta = const VerificationMeta(
    'smokingLogId',
  );
  @override
  late final GeneratedColumn<String> smokingLogId = GeneratedColumn<String>(
    'smoking_log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES smoking_logs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _triggerIdMeta = const VerificationMeta(
    'triggerId',
  );
  @override
  late final GeneratedColumn<String> triggerId = GeneratedColumn<String>(
    'trigger_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES triggers (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [smokingLogId, triggerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smoking_log_triggers';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmokingLogTrigger> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('smoking_log_id')) {
      context.handle(
        _smokingLogIdMeta,
        smokingLogId.isAcceptableOrUnknown(
          data['smoking_log_id']!,
          _smokingLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_smokingLogIdMeta);
    }
    if (data.containsKey('trigger_id')) {
      context.handle(
        _triggerIdMeta,
        triggerId.isAcceptableOrUnknown(data['trigger_id']!, _triggerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_triggerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {smokingLogId, triggerId};
  @override
  SmokingLogTrigger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmokingLogTrigger(
      smokingLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smoking_log_id'],
      )!,
      triggerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_id'],
      )!,
    );
  }

  @override
  $SmokingLogTriggersTable createAlias(String alias) {
    return $SmokingLogTriggersTable(attachedDatabase, alias);
  }
}

class SmokingLogTrigger extends DataClass
    implements Insertable<SmokingLogTrigger> {
  final String smokingLogId;
  final String triggerId;
  const SmokingLogTrigger({
    required this.smokingLogId,
    required this.triggerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['smoking_log_id'] = Variable<String>(smokingLogId);
    map['trigger_id'] = Variable<String>(triggerId);
    return map;
  }

  SmokingLogTriggersCompanion toCompanion(bool nullToAbsent) {
    return SmokingLogTriggersCompanion(
      smokingLogId: Value(smokingLogId),
      triggerId: Value(triggerId),
    );
  }

  factory SmokingLogTrigger.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmokingLogTrigger(
      smokingLogId: serializer.fromJson<String>(json['smokingLogId']),
      triggerId: serializer.fromJson<String>(json['triggerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'smokingLogId': serializer.toJson<String>(smokingLogId),
      'triggerId': serializer.toJson<String>(triggerId),
    };
  }

  SmokingLogTrigger copyWith({String? smokingLogId, String? triggerId}) =>
      SmokingLogTrigger(
        smokingLogId: smokingLogId ?? this.smokingLogId,
        triggerId: triggerId ?? this.triggerId,
      );
  SmokingLogTrigger copyWithCompanion(SmokingLogTriggersCompanion data) {
    return SmokingLogTrigger(
      smokingLogId: data.smokingLogId.present
          ? data.smokingLogId.value
          : this.smokingLogId,
      triggerId: data.triggerId.present ? data.triggerId.value : this.triggerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmokingLogTrigger(')
          ..write('smokingLogId: $smokingLogId, ')
          ..write('triggerId: $triggerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(smokingLogId, triggerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmokingLogTrigger &&
          other.smokingLogId == this.smokingLogId &&
          other.triggerId == this.triggerId);
}

class SmokingLogTriggersCompanion extends UpdateCompanion<SmokingLogTrigger> {
  final Value<String> smokingLogId;
  final Value<String> triggerId;
  final Value<int> rowid;
  const SmokingLogTriggersCompanion({
    this.smokingLogId = const Value.absent(),
    this.triggerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmokingLogTriggersCompanion.insert({
    required String smokingLogId,
    required String triggerId,
    this.rowid = const Value.absent(),
  }) : smokingLogId = Value(smokingLogId),
       triggerId = Value(triggerId);
  static Insertable<SmokingLogTrigger> custom({
    Expression<String>? smokingLogId,
    Expression<String>? triggerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (smokingLogId != null) 'smoking_log_id': smokingLogId,
      if (triggerId != null) 'trigger_id': triggerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmokingLogTriggersCompanion copyWith({
    Value<String>? smokingLogId,
    Value<String>? triggerId,
    Value<int>? rowid,
  }) {
    return SmokingLogTriggersCompanion(
      smokingLogId: smokingLogId ?? this.smokingLogId,
      triggerId: triggerId ?? this.triggerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (smokingLogId.present) {
      map['smoking_log_id'] = Variable<String>(smokingLogId.value);
    }
    if (triggerId.present) {
      map['trigger_id'] = Variable<String>(triggerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmokingLogTriggersCompanion(')
          ..write('smokingLogId: $smokingLogId, ')
          ..write('triggerId: $triggerId, ')
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
  late final $SmokingLogsTable smokingLogs = $SmokingLogsTable(this);
  late final $TriggersTable triggers = $TriggersTable(this);
  late final $SmokingLogTriggersTable smokingLogTriggers =
      $SmokingLogTriggersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadata,
    userProfiles,
    motivations,
    smokingLogs,
    triggers,
    smokingLogTriggers,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'smoking_logs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('smoking_log_triggers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'triggers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('smoking_log_triggers', kind: UpdateKind.delete)],
    ),
  ]);
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
typedef $$SmokingLogsTableCreateCompanionBuilder =
    SmokingLogsCompanion Function({
      required String id,
      required DateTime smokedAt,
      Value<int?> cravingLevel,
      Value<String?> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SmokingLogsTableUpdateCompanionBuilder =
    SmokingLogsCompanion Function({
      Value<String> id,
      Value<DateTime> smokedAt,
      Value<int?> cravingLevel,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SmokingLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SmokingLogsTable, SmokingLog> {
  $$SmokingLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SmokingLogTriggersTable, List<SmokingLogTrigger>>
  _smokingLogTriggersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.smokingLogTriggers,
        aliasName: 'smoking_logs__id__smoking_log_triggers__smoking_log_id',
      );

  $$SmokingLogTriggersTableProcessedTableManager get smokingLogTriggersRefs {
    final manager = $$SmokingLogTriggersTableTableManager(
      $_db,
      $_db.smokingLogTriggers,
    ).filter((f) => f.smokingLogId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _smokingLogTriggersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SmokingLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SmokingLogsTable> {
  $$SmokingLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get smokedAt => $composableBuilder(
    column: $table.smokedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cravingLevel => $composableBuilder(
    column: $table.cravingLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> smokingLogTriggersRefs(
    Expression<bool> Function($$SmokingLogTriggersTableFilterComposer f) f,
  ) {
    final $$SmokingLogTriggersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smokingLogTriggers,
      getReferencedColumn: (t) => t.smokingLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmokingLogTriggersTableFilterComposer(
            $db: $db,
            $table: $db.smokingLogTriggers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SmokingLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SmokingLogsTable> {
  $$SmokingLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get smokedAt => $composableBuilder(
    column: $table.smokedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cravingLevel => $composableBuilder(
    column: $table.cravingLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmokingLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmokingLogsTable> {
  $$SmokingLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get smokedAt =>
      $composableBuilder(column: $table.smokedAt, builder: (column) => column);

  GeneratedColumn<int> get cravingLevel => $composableBuilder(
    column: $table.cravingLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> smokingLogTriggersRefs<T extends Object>(
    Expression<T> Function($$SmokingLogTriggersTableAnnotationComposer a) f,
  ) {
    final $$SmokingLogTriggersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.smokingLogTriggers,
          getReferencedColumn: (t) => t.smokingLogId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SmokingLogTriggersTableAnnotationComposer(
                $db: $db,
                $table: $db.smokingLogTriggers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SmokingLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmokingLogsTable,
          SmokingLog,
          $$SmokingLogsTableFilterComposer,
          $$SmokingLogsTableOrderingComposer,
          $$SmokingLogsTableAnnotationComposer,
          $$SmokingLogsTableCreateCompanionBuilder,
          $$SmokingLogsTableUpdateCompanionBuilder,
          (SmokingLog, $$SmokingLogsTableReferences),
          SmokingLog,
          PrefetchHooks Function({bool smokingLogTriggersRefs})
        > {
  $$SmokingLogsTableTableManager(_$AppDatabase db, $SmokingLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmokingLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmokingLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmokingLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> smokedAt = const Value.absent(),
                Value<int?> cravingLevel = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmokingLogsCompanion(
                id: id,
                smokedAt: smokedAt,
                cravingLevel: cravingLevel,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime smokedAt,
                Value<int?> cravingLevel = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SmokingLogsCompanion.insert(
                id: id,
                smokedAt: smokedAt,
                cravingLevel: cravingLevel,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SmokingLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({smokingLogTriggersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (smokingLogTriggersRefs) db.smokingLogTriggers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (smokingLogTriggersRefs)
                    await $_getPrefetchedData<
                      SmokingLog,
                      $SmokingLogsTable,
                      SmokingLogTrigger
                    >(
                      currentTable: table,
                      referencedTable: $$SmokingLogsTableReferences
                          ._smokingLogTriggersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SmokingLogsTableReferences(
                            db,
                            table,
                            p0,
                          ).smokingLogTriggersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.smokingLogId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SmokingLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmokingLogsTable,
      SmokingLog,
      $$SmokingLogsTableFilterComposer,
      $$SmokingLogsTableOrderingComposer,
      $$SmokingLogsTableAnnotationComposer,
      $$SmokingLogsTableCreateCompanionBuilder,
      $$SmokingLogsTableUpdateCompanionBuilder,
      (SmokingLog, $$SmokingLogsTableReferences),
      SmokingLog,
      PrefetchHooks Function({bool smokingLogTriggersRefs})
    >;
typedef $$TriggersTableCreateCompanionBuilder =
    TriggersCompanion Function({
      required String id,
      required String name,
      Value<bool> isDefault,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TriggersTableUpdateCompanionBuilder =
    TriggersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TriggersTableReferences
    extends BaseReferences<_$AppDatabase, $TriggersTable, Trigger> {
  $$TriggersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SmokingLogTriggersTable, List<SmokingLogTrigger>>
  _smokingLogTriggersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.smokingLogTriggers,
        aliasName: 'triggers__id__smoking_log_triggers__trigger_id',
      );

  $$SmokingLogTriggersTableProcessedTableManager get smokingLogTriggersRefs {
    final manager = $$SmokingLogTriggersTableTableManager(
      $_db,
      $_db.smokingLogTriggers,
    ).filter((f) => f.triggerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _smokingLogTriggersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TriggersTableFilterComposer
    extends Composer<_$AppDatabase, $TriggersTable> {
  $$TriggersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> smokingLogTriggersRefs(
    Expression<bool> Function($$SmokingLogTriggersTableFilterComposer f) f,
  ) {
    final $$SmokingLogTriggersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smokingLogTriggers,
      getReferencedColumn: (t) => t.triggerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmokingLogTriggersTableFilterComposer(
            $db: $db,
            $table: $db.smokingLogTriggers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TriggersTableOrderingComposer
    extends Composer<_$AppDatabase, $TriggersTable> {
  $$TriggersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TriggersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriggersTable> {
  $$TriggersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> smokingLogTriggersRefs<T extends Object>(
    Expression<T> Function($$SmokingLogTriggersTableAnnotationComposer a) f,
  ) {
    final $$SmokingLogTriggersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.smokingLogTriggers,
          getReferencedColumn: (t) => t.triggerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SmokingLogTriggersTableAnnotationComposer(
                $db: $db,
                $table: $db.smokingLogTriggers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TriggersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriggersTable,
          Trigger,
          $$TriggersTableFilterComposer,
          $$TriggersTableOrderingComposer,
          $$TriggersTableAnnotationComposer,
          $$TriggersTableCreateCompanionBuilder,
          $$TriggersTableUpdateCompanionBuilder,
          (Trigger, $$TriggersTableReferences),
          Trigger,
          PrefetchHooks Function({bool smokingLogTriggersRefs})
        > {
  $$TriggersTableTableManager(_$AppDatabase db, $TriggersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriggersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriggersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TriggersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TriggersCompanion(
                id: id,
                name: name,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<bool> isDefault = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TriggersCompanion.insert(
                id: id,
                name: name,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TriggersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({smokingLogTriggersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (smokingLogTriggersRefs) db.smokingLogTriggers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (smokingLogTriggersRefs)
                    await $_getPrefetchedData<
                      Trigger,
                      $TriggersTable,
                      SmokingLogTrigger
                    >(
                      currentTable: table,
                      referencedTable: $$TriggersTableReferences
                          ._smokingLogTriggersRefsTable(db),
                      managerFromTypedResult: (p0) => $$TriggersTableReferences(
                        db,
                        table,
                        p0,
                      ).smokingLogTriggersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.triggerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TriggersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriggersTable,
      Trigger,
      $$TriggersTableFilterComposer,
      $$TriggersTableOrderingComposer,
      $$TriggersTableAnnotationComposer,
      $$TriggersTableCreateCompanionBuilder,
      $$TriggersTableUpdateCompanionBuilder,
      (Trigger, $$TriggersTableReferences),
      Trigger,
      PrefetchHooks Function({bool smokingLogTriggersRefs})
    >;
typedef $$SmokingLogTriggersTableCreateCompanionBuilder =
    SmokingLogTriggersCompanion Function({
      required String smokingLogId,
      required String triggerId,
      Value<int> rowid,
    });
typedef $$SmokingLogTriggersTableUpdateCompanionBuilder =
    SmokingLogTriggersCompanion Function({
      Value<String> smokingLogId,
      Value<String> triggerId,
      Value<int> rowid,
    });

final class $$SmokingLogTriggersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SmokingLogTriggersTable,
          SmokingLogTrigger
        > {
  $$SmokingLogTriggersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SmokingLogsTable _smokingLogIdTable(_$AppDatabase db) => db
      .smokingLogs
      .createAlias('smoking_log_triggers__smoking_log_id__smoking_logs__id');

  $$SmokingLogsTableProcessedTableManager get smokingLogId {
    final $_column = $_itemColumn<String>('smoking_log_id')!;

    final manager = $$SmokingLogsTableTableManager(
      $_db,
      $_db.smokingLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_smokingLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TriggersTable _triggerIdTable(_$AppDatabase db) =>
      db.triggers.createAlias('smoking_log_triggers__trigger_id__triggers__id');

  $$TriggersTableProcessedTableManager get triggerId {
    final $_column = $_itemColumn<String>('trigger_id')!;

    final manager = $$TriggersTableTableManager(
      $_db,
      $_db.triggers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_triggerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SmokingLogTriggersTableFilterComposer
    extends Composer<_$AppDatabase, $SmokingLogTriggersTable> {
  $$SmokingLogTriggersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SmokingLogsTableFilterComposer get smokingLogId {
    final $$SmokingLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smokingLogId,
      referencedTable: $db.smokingLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmokingLogsTableFilterComposer(
            $db: $db,
            $table: $db.smokingLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TriggersTableFilterComposer get triggerId {
    final $$TriggersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.triggerId,
      referencedTable: $db.triggers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggersTableFilterComposer(
            $db: $db,
            $table: $db.triggers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmokingLogTriggersTableOrderingComposer
    extends Composer<_$AppDatabase, $SmokingLogTriggersTable> {
  $$SmokingLogTriggersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SmokingLogsTableOrderingComposer get smokingLogId {
    final $$SmokingLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smokingLogId,
      referencedTable: $db.smokingLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmokingLogsTableOrderingComposer(
            $db: $db,
            $table: $db.smokingLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TriggersTableOrderingComposer get triggerId {
    final $$TriggersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.triggerId,
      referencedTable: $db.triggers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggersTableOrderingComposer(
            $db: $db,
            $table: $db.triggers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmokingLogTriggersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmokingLogTriggersTable> {
  $$SmokingLogTriggersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SmokingLogsTableAnnotationComposer get smokingLogId {
    final $$SmokingLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smokingLogId,
      referencedTable: $db.smokingLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmokingLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.smokingLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TriggersTableAnnotationComposer get triggerId {
    final $$TriggersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.triggerId,
      referencedTable: $db.triggers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggersTableAnnotationComposer(
            $db: $db,
            $table: $db.triggers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmokingLogTriggersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmokingLogTriggersTable,
          SmokingLogTrigger,
          $$SmokingLogTriggersTableFilterComposer,
          $$SmokingLogTriggersTableOrderingComposer,
          $$SmokingLogTriggersTableAnnotationComposer,
          $$SmokingLogTriggersTableCreateCompanionBuilder,
          $$SmokingLogTriggersTableUpdateCompanionBuilder,
          (SmokingLogTrigger, $$SmokingLogTriggersTableReferences),
          SmokingLogTrigger,
          PrefetchHooks Function({bool smokingLogId, bool triggerId})
        > {
  $$SmokingLogTriggersTableTableManager(
    _$AppDatabase db,
    $SmokingLogTriggersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmokingLogTriggersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmokingLogTriggersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmokingLogTriggersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> smokingLogId = const Value.absent(),
                Value<String> triggerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmokingLogTriggersCompanion(
                smokingLogId: smokingLogId,
                triggerId: triggerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String smokingLogId,
                required String triggerId,
                Value<int> rowid = const Value.absent(),
              }) => SmokingLogTriggersCompanion.insert(
                smokingLogId: smokingLogId,
                triggerId: triggerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SmokingLogTriggersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({smokingLogId = false, triggerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (smokingLogId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.smokingLogId,
                                referencedTable:
                                    $$SmokingLogTriggersTableReferences
                                        ._smokingLogIdTable(db),
                                referencedColumn:
                                    $$SmokingLogTriggersTableReferences
                                        ._smokingLogIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (triggerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.triggerId,
                                referencedTable:
                                    $$SmokingLogTriggersTableReferences
                                        ._triggerIdTable(db),
                                referencedColumn:
                                    $$SmokingLogTriggersTableReferences
                                        ._triggerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SmokingLogTriggersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmokingLogTriggersTable,
      SmokingLogTrigger,
      $$SmokingLogTriggersTableFilterComposer,
      $$SmokingLogTriggersTableOrderingComposer,
      $$SmokingLogTriggersTableAnnotationComposer,
      $$SmokingLogTriggersTableCreateCompanionBuilder,
      $$SmokingLogTriggersTableUpdateCompanionBuilder,
      (SmokingLogTrigger, $$SmokingLogTriggersTableReferences),
      SmokingLogTrigger,
      PrefetchHooks Function({bool smokingLogId, bool triggerId})
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
  $$SmokingLogsTableTableManager get smokingLogs =>
      $$SmokingLogsTableTableManager(_db, _db.smokingLogs);
  $$TriggersTableTableManager get triggers =>
      $$TriggersTableTableManager(_db, _db.triggers);
  $$SmokingLogTriggersTableTableManager get smokingLogTriggers =>
      $$SmokingLogTriggersTableTableManager(_db, _db.smokingLogTriggers);
}
