// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BudgetCyclesTable extends BudgetCycles
    with TableInfo<$BudgetCyclesTable, BudgetCycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configuredStartDayMeta =
      const VerificationMeta('configuredStartDay');
  @override
  late final GeneratedColumn<int> configuredStartDay = GeneratedColumn<int>(
    'configured_start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _salaryAmountMeta = const VerificationMeta(
    'salaryAmount',
  );
  @override
  late final GeneratedColumn<double> salaryAmount = GeneratedColumn<double>(
    'salary_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(72000.0),
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    configuredStartDay,
    salaryAmount,
    isClosed,
    createdAt,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('configured_start_day')) {
      context.handle(
        _configuredStartDayMeta,
        configuredStartDay.isAcceptableOrUnknown(
          data['configured_start_day']!,
          _configuredStartDayMeta,
        ),
      );
    }
    if (data.containsKey('salary_amount')) {
      context.handle(
        _salaryAmountMeta,
        salaryAmount.isAcceptableOrUnknown(
          data['salary_amount']!,
          _salaryAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      configuredStartDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}configured_start_day'],
      )!,
      salaryAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salary_amount'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
    );
  }

  @override
  $BudgetCyclesTable createAlias(String alias) {
    return $BudgetCyclesTable(attachedDatabase, alias);
  }
}

class BudgetCycle extends DataClass implements Insertable<BudgetCycle> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int configuredStartDay;
  final double salaryAmount;
  final bool isClosed;
  final DateTime createdAt;
  final DateTime? closedAt;
  const BudgetCycle({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.configuredStartDay,
    required this.salaryAmount,
    required this.isClosed,
    required this.createdAt,
    this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['configured_start_day'] = Variable<int>(configuredStartDay);
    map['salary_amount'] = Variable<double>(salaryAmount);
    map['is_closed'] = Variable<bool>(isClosed);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    return map;
  }

  BudgetCyclesCompanion toCompanion(bool nullToAbsent) {
    return BudgetCyclesCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      configuredStartDay: Value(configuredStartDay),
      salaryAmount: Value(salaryAmount),
      isClosed: Value(isClosed),
      createdAt: Value(createdAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
    );
  }

  factory BudgetCycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCycle(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      configuredStartDay: serializer.fromJson<int>(json['configuredStartDay']),
      salaryAmount: serializer.fromJson<double>(json['salaryAmount']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'configuredStartDay': serializer.toJson<int>(configuredStartDay),
      'salaryAmount': serializer.toJson<double>(salaryAmount),
      'isClosed': serializer.toJson<bool>(isClosed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
    };
  }

  BudgetCycle copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? configuredStartDay,
    double? salaryAmount,
    bool? isClosed,
    DateTime? createdAt,
    Value<DateTime?> closedAt = const Value.absent(),
  }) => BudgetCycle(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    configuredStartDay: configuredStartDay ?? this.configuredStartDay,
    salaryAmount: salaryAmount ?? this.salaryAmount,
    isClosed: isClosed ?? this.isClosed,
    createdAt: createdAt ?? this.createdAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
  );
  BudgetCycle copyWithCompanion(BudgetCyclesCompanion data) {
    return BudgetCycle(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      configuredStartDay: data.configuredStartDay.present
          ? data.configuredStartDay.value
          : this.configuredStartDay,
      salaryAmount: data.salaryAmount.present
          ? data.salaryAmount.value
          : this.salaryAmount,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCycle(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('configuredStartDay: $configuredStartDay, ')
          ..write('salaryAmount: $salaryAmount, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startDate,
    endDate,
    configuredStartDay,
    salaryAmount,
    isClosed,
    createdAt,
    closedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCycle &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.configuredStartDay == this.configuredStartDay &&
          other.salaryAmount == this.salaryAmount &&
          other.isClosed == this.isClosed &&
          other.createdAt == this.createdAt &&
          other.closedAt == this.closedAt);
}

class BudgetCyclesCompanion extends UpdateCompanion<BudgetCycle> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> configuredStartDay;
  final Value<double> salaryAmount;
  final Value<bool> isClosed;
  final Value<DateTime> createdAt;
  final Value<DateTime?> closedAt;
  const BudgetCyclesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.configuredStartDay = const Value.absent(),
    this.salaryAmount = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
  });
  BudgetCyclesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.configuredStartDay = const Value.absent(),
    this.salaryAmount = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<BudgetCycle> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? configuredStartDay,
    Expression<double>? salaryAmount,
    Expression<bool>? isClosed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? closedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (configuredStartDay != null)
        'configured_start_day': configuredStartDay,
      if (salaryAmount != null) 'salary_amount': salaryAmount,
      if (isClosed != null) 'is_closed': isClosed,
      if (createdAt != null) 'created_at': createdAt,
      if (closedAt != null) 'closed_at': closedAt,
    });
  }

  BudgetCyclesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? configuredStartDay,
    Value<double>? salaryAmount,
    Value<bool>? isClosed,
    Value<DateTime>? createdAt,
    Value<DateTime?>? closedAt,
  }) {
    return BudgetCyclesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      configuredStartDay: configuredStartDay ?? this.configuredStartDay,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      isClosed: isClosed ?? this.isClosed,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (configuredStartDay.present) {
      map['configured_start_day'] = Variable<int>(configuredStartDay.value);
    }
    if (salaryAmount.present) {
      map['salary_amount'] = Variable<double>(salaryAmount.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCyclesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('configuredStartDay: $configuredStartDay, ')
          ..write('salaryAmount: $salaryAmount, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }
}

class $SupplementaryIncomesTable extends SupplementaryIncomes
    with TableInfo<$SupplementaryIncomesTable, SupplementaryIncome> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementaryIncomesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, cycleId, label, amount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplementary_incomes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementaryIncome> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementaryIncome map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementaryIncome(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SupplementaryIncomesTable createAlias(String alias) {
    return $SupplementaryIncomesTable(attachedDatabase, alias);
  }
}

class SupplementaryIncome extends DataClass
    implements Insertable<SupplementaryIncome> {
  final int id;
  final int cycleId;
  final String label;
  final double amount;
  final DateTime createdAt;
  const SupplementaryIncome({
    required this.id,
    required this.cycleId,
    required this.label,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['label'] = Variable<String>(label);
    map['amount'] = Variable<double>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SupplementaryIncomesCompanion toCompanion(bool nullToAbsent) {
    return SupplementaryIncomesCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      label: Value(label),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory SupplementaryIncome.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementaryIncome(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      label: serializer.fromJson<String>(json['label']),
      amount: serializer.fromJson<double>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'label': serializer.toJson<String>(label),
      'amount': serializer.toJson<double>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupplementaryIncome copyWith({
    int? id,
    int? cycleId,
    String? label,
    double? amount,
    DateTime? createdAt,
  }) => SupplementaryIncome(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    label: label ?? this.label,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  SupplementaryIncome copyWithCompanion(SupplementaryIncomesCompanion data) {
    return SupplementaryIncome(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      label: data.label.present ? data.label.value : this.label,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementaryIncome(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('label: $label, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cycleId, label, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementaryIncome &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.label == this.label &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class SupplementaryIncomesCompanion
    extends UpdateCompanion<SupplementaryIncome> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<String> label;
  final Value<double> amount;
  final Value<DateTime> createdAt;
  const SupplementaryIncomesCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.label = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SupplementaryIncomesCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required String label,
    required double amount,
    this.createdAt = const Value.absent(),
  }) : cycleId = Value(cycleId),
       label = Value(label),
       amount = Value(amount);
  static Insertable<SupplementaryIncome> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<String>? label,
    Expression<double>? amount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (label != null) 'label': label,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SupplementaryIncomesCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<String>? label,
    Value<double>? amount,
    Value<DateTime>? createdAt,
  }) {
    return SupplementaryIncomesCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      label: label ?? this.label,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementaryIncomesCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('label: $label, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _categoryTypeMeta = const VerificationMeta(
    'categoryType',
  );
  @override
  late final GeneratedColumn<String> categoryType = GeneratedColumn<String>(
    'category_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allocatedAmountMeta = const VerificationMeta(
    'allocatedAmount',
  );
  @override
  late final GeneratedColumn<double> allocatedAmount = GeneratedColumn<double>(
    'allocated_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    name,
    categoryType,
    allocatedAmount,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_type')) {
      context.handle(
        _categoryTypeMeta,
        categoryType.isAcceptableOrUnknown(
          data['category_type']!,
          _categoryTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryTypeMeta);
    }
    if (data.containsKey('allocated_amount')) {
      context.handle(
        _allocatedAmountMeta,
        allocatedAmount.isAcceptableOrUnknown(
          data['allocated_amount']!,
          _allocatedAmountMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_type'],
      )!,
      allocatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}allocated_amount'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final int cycleId;
  final String name;

  /// 'savings', 'wants', or 'needs'
  final String categoryType;
  final double allocatedAmount;
  final int sortOrder;
  const Category({
    required this.id,
    required this.cycleId,
    required this.name,
    required this.categoryType,
    required this.allocatedAmount,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['name'] = Variable<String>(name);
    map['category_type'] = Variable<String>(categoryType);
    map['allocated_amount'] = Variable<double>(allocatedAmount);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      name: Value(name),
      categoryType: Value(categoryType),
      allocatedAmount: Value(allocatedAmount),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      name: serializer.fromJson<String>(json['name']),
      categoryType: serializer.fromJson<String>(json['categoryType']),
      allocatedAmount: serializer.fromJson<double>(json['allocatedAmount']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'name': serializer.toJson<String>(name),
      'categoryType': serializer.toJson<String>(categoryType),
      'allocatedAmount': serializer.toJson<double>(allocatedAmount),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    int? id,
    int? cycleId,
    String? name,
    String? categoryType,
    double? allocatedAmount,
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    name: name ?? this.name,
    categoryType: categoryType ?? this.categoryType,
    allocatedAmount: allocatedAmount ?? this.allocatedAmount,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      name: data.name.present ? data.name.value : this.name,
      categoryType: data.categoryType.present
          ? data.categoryType.value
          : this.categoryType,
      allocatedAmount: data.allocatedAmount.present
          ? data.allocatedAmount.value
          : this.allocatedAmount,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('name: $name, ')
          ..write('categoryType: $categoryType, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cycleId, name, categoryType, allocatedAmount, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.name == this.name &&
          other.categoryType == this.categoryType &&
          other.allocatedAmount == this.allocatedAmount &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<String> name;
  final Value<String> categoryType;
  final Value<double> allocatedAmount;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryType = const Value.absent(),
    this.allocatedAmount = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required String name,
    required String categoryType,
    this.allocatedAmount = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : cycleId = Value(cycleId),
       name = Value(name),
       categoryType = Value(categoryType);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<String>? name,
    Expression<String>? categoryType,
    Expression<double>? allocatedAmount,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (name != null) 'name': name,
      if (categoryType != null) 'category_type': categoryType,
      if (allocatedAmount != null) 'allocated_amount': allocatedAmount,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<String>? name,
    Value<String>? categoryType,
    Value<double>? allocatedAmount,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      name: name ?? this.name,
      categoryType: categoryType ?? this.categoryType,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryType.present) {
      map['category_type'] = Variable<String>(categoryType.value);
    }
    if (allocatedAmount.present) {
      map['allocated_amount'] = Variable<double>(allocatedAmount.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('name: $name, ')
          ..write('categoryType: $categoryType, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $SubsectionsTable extends Subsections
    with TableInfo<$SubsectionsTable, Subsection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubsectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _allocatedAmountMeta = const VerificationMeta(
    'allocatedAmount',
  );
  @override
  late final GeneratedColumn<double> allocatedAmount = GeneratedColumn<double>(
    'allocated_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _actualAmountMeta = const VerificationMeta(
    'actualAmount',
  );
  @override
  late final GeneratedColumn<double> actualAmount = GeneratedColumn<double>(
    'actual_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isFoodLinkedMeta = const VerificationMeta(
    'isFoodLinked',
  );
  @override
  late final GeneratedColumn<bool> isFoodLinked = GeneratedColumn<bool>(
    'is_food_linked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_food_linked" IN (0, 1))',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    parentId,
    name,
    allocatedAmount,
    actualAmount,
    isFoodLinked,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subsections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subsection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('allocated_amount')) {
      context.handle(
        _allocatedAmountMeta,
        allocatedAmount.isAcceptableOrUnknown(
          data['allocated_amount']!,
          _allocatedAmountMeta,
        ),
      );
    }
    if (data.containsKey('actual_amount')) {
      context.handle(
        _actualAmountMeta,
        actualAmount.isAcceptableOrUnknown(
          data['actual_amount']!,
          _actualAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_food_linked')) {
      context.handle(
        _isFoodLinkedMeta,
        isFoodLinked.isAcceptableOrUnknown(
          data['is_food_linked']!,
          _isFoodLinkedMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subsection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subsection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      allocatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}allocated_amount'],
      )!,
      actualAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_amount'],
      )!,
      isFoodLinked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_food_linked'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SubsectionsTable createAlias(String alias) {
    return $SubsectionsTable(attachedDatabase, alias);
  }
}

class Subsection extends DataClass implements Insertable<Subsection> {
  final int id;
  final int categoryId;
  final int? parentId;
  final String name;
  final double allocatedAmount;
  final double actualAmount;
  final bool isFoodLinked;
  final int sortOrder;
  const Subsection({
    required this.id,
    required this.categoryId,
    this.parentId,
    required this.name,
    required this.allocatedAmount,
    required this.actualAmount,
    required this.isFoodLinked,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['allocated_amount'] = Variable<double>(allocatedAmount);
    map['actual_amount'] = Variable<double>(actualAmount);
    map['is_food_linked'] = Variable<bool>(isFoodLinked);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SubsectionsCompanion toCompanion(bool nullToAbsent) {
    return SubsectionsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      allocatedAmount: Value(allocatedAmount),
      actualAmount: Value(actualAmount),
      isFoodLinked: Value(isFoodLinked),
      sortOrder: Value(sortOrder),
    );
  }

  factory Subsection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subsection(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      allocatedAmount: serializer.fromJson<double>(json['allocatedAmount']),
      actualAmount: serializer.fromJson<double>(json['actualAmount']),
      isFoodLinked: serializer.fromJson<bool>(json['isFoodLinked']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'parentId': serializer.toJson<int?>(parentId),
      'name': serializer.toJson<String>(name),
      'allocatedAmount': serializer.toJson<double>(allocatedAmount),
      'actualAmount': serializer.toJson<double>(actualAmount),
      'isFoodLinked': serializer.toJson<bool>(isFoodLinked),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Subsection copyWith({
    int? id,
    int? categoryId,
    Value<int?> parentId = const Value.absent(),
    String? name,
    double? allocatedAmount,
    double? actualAmount,
    bool? isFoodLinked,
    int? sortOrder,
  }) => Subsection(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    allocatedAmount: allocatedAmount ?? this.allocatedAmount,
    actualAmount: actualAmount ?? this.actualAmount,
    isFoodLinked: isFoodLinked ?? this.isFoodLinked,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Subsection copyWithCompanion(SubsectionsCompanion data) {
    return Subsection(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      allocatedAmount: data.allocatedAmount.present
          ? data.allocatedAmount.value
          : this.allocatedAmount,
      actualAmount: data.actualAmount.present
          ? data.actualAmount.value
          : this.actualAmount,
      isFoodLinked: data.isFoodLinked.present
          ? data.isFoodLinked.value
          : this.isFoodLinked,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subsection(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('isFoodLinked: $isFoodLinked, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    parentId,
    name,
    allocatedAmount,
    actualAmount,
    isFoodLinked,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subsection &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.allocatedAmount == this.allocatedAmount &&
          other.actualAmount == this.actualAmount &&
          other.isFoodLinked == this.isFoodLinked &&
          other.sortOrder == this.sortOrder);
}

class SubsectionsCompanion extends UpdateCompanion<Subsection> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<int?> parentId;
  final Value<String> name;
  final Value<double> allocatedAmount;
  final Value<double> actualAmount;
  final Value<bool> isFoodLinked;
  final Value<int> sortOrder;
  const SubsectionsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.allocatedAmount = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.isFoodLinked = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  SubsectionsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    this.parentId = const Value.absent(),
    required String name,
    this.allocatedAmount = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.isFoodLinked = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : categoryId = Value(categoryId),
       name = Value(name);
  static Insertable<Subsection> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<int>? parentId,
    Expression<String>? name,
    Expression<double>? allocatedAmount,
    Expression<double>? actualAmount,
    Expression<bool>? isFoodLinked,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (allocatedAmount != null) 'allocated_amount': allocatedAmount,
      if (actualAmount != null) 'actual_amount': actualAmount,
      if (isFoodLinked != null) 'is_food_linked': isFoodLinked,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  SubsectionsCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<int?>? parentId,
    Value<String>? name,
    Value<double>? allocatedAmount,
    Value<double>? actualAmount,
    Value<bool>? isFoodLinked,
    Value<int>? sortOrder,
  }) {
    return SubsectionsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      actualAmount: actualAmount ?? this.actualAmount,
      isFoodLinked: isFoodLinked ?? this.isFoodLinked,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (allocatedAmount.present) {
      map['allocated_amount'] = Variable<double>(allocatedAmount.value);
    }
    if (actualAmount.present) {
      map['actual_amount'] = Variable<double>(actualAmount.value);
    }
    if (isFoodLinked.present) {
      map['is_food_linked'] = Variable<bool>(isFoodLinked.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubsectionsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('isFoodLinked: $isFoodLinked, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $SubsectionEntriesTable extends SubsectionEntries
    with TableInfo<$SubsectionEntriesTable, SubsectionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubsectionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subsectionIdMeta = const VerificationMeta(
    'subsectionId',
  );
  @override
  late final GeneratedColumn<int> subsectionId = GeneratedColumn<int>(
    'subsection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subsectionId,
    amount,
    note,
    entryDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subsection_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubsectionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subsection_id')) {
      context.handle(
        _subsectionIdMeta,
        subsectionId.isAcceptableOrUnknown(
          data['subsection_id']!,
          _subsectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subsectionIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubsectionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubsectionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subsectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subsection_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
    );
  }

  @override
  $SubsectionEntriesTable createAlias(String alias) {
    return $SubsectionEntriesTable(attachedDatabase, alias);
  }
}

class SubsectionEntry extends DataClass implements Insertable<SubsectionEntry> {
  final int id;
  final int subsectionId;
  final double amount;
  final String note;
  final DateTime entryDate;
  const SubsectionEntry({
    required this.id,
    required this.subsectionId,
    required this.amount,
    required this.note,
    required this.entryDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subsection_id'] = Variable<int>(subsectionId);
    map['amount'] = Variable<double>(amount);
    map['note'] = Variable<String>(note);
    map['entry_date'] = Variable<DateTime>(entryDate);
    return map;
  }

  SubsectionEntriesCompanion toCompanion(bool nullToAbsent) {
    return SubsectionEntriesCompanion(
      id: Value(id),
      subsectionId: Value(subsectionId),
      amount: Value(amount),
      note: Value(note),
      entryDate: Value(entryDate),
    );
  }

  factory SubsectionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubsectionEntry(
      id: serializer.fromJson<int>(json['id']),
      subsectionId: serializer.fromJson<int>(json['subsectionId']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String>(json['note']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subsectionId': serializer.toJson<int>(subsectionId),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String>(note),
      'entryDate': serializer.toJson<DateTime>(entryDate),
    };
  }

  SubsectionEntry copyWith({
    int? id,
    int? subsectionId,
    double? amount,
    String? note,
    DateTime? entryDate,
  }) => SubsectionEntry(
    id: id ?? this.id,
    subsectionId: subsectionId ?? this.subsectionId,
    amount: amount ?? this.amount,
    note: note ?? this.note,
    entryDate: entryDate ?? this.entryDate,
  );
  SubsectionEntry copyWithCompanion(SubsectionEntriesCompanion data) {
    return SubsectionEntry(
      id: data.id.present ? data.id.value : this.id,
      subsectionId: data.subsectionId.present
          ? data.subsectionId.value
          : this.subsectionId,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubsectionEntry(')
          ..write('id: $id, ')
          ..write('subsectionId: $subsectionId, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('entryDate: $entryDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subsectionId, amount, note, entryDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubsectionEntry &&
          other.id == this.id &&
          other.subsectionId == this.subsectionId &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.entryDate == this.entryDate);
}

class SubsectionEntriesCompanion extends UpdateCompanion<SubsectionEntry> {
  final Value<int> id;
  final Value<int> subsectionId;
  final Value<double> amount;
  final Value<String> note;
  final Value<DateTime> entryDate;
  const SubsectionEntriesCompanion({
    this.id = const Value.absent(),
    this.subsectionId = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.entryDate = const Value.absent(),
  });
  SubsectionEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int subsectionId,
    required double amount,
    this.note = const Value.absent(),
    this.entryDate = const Value.absent(),
  }) : subsectionId = Value(subsectionId),
       amount = Value(amount);
  static Insertable<SubsectionEntry> custom({
    Expression<int>? id,
    Expression<int>? subsectionId,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<DateTime>? entryDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subsectionId != null) 'subsection_id': subsectionId,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (entryDate != null) 'entry_date': entryDate,
    });
  }

  SubsectionEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? subsectionId,
    Value<double>? amount,
    Value<String>? note,
    Value<DateTime>? entryDate,
  }) {
    return SubsectionEntriesCompanion(
      id: id ?? this.id,
      subsectionId: subsectionId ?? this.subsectionId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      entryDate: entryDate ?? this.entryDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subsectionId.present) {
      map['subsection_id'] = Variable<int>(subsectionId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubsectionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('subsectionId: $subsectionId, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('entryDate: $entryDate')
          ..write(')'))
        .toString();
  }
}

class $SavingsShortfallLogsTable extends SavingsShortfallLogs
    with TableInfo<$SavingsShortfallLogsTable, SavingsShortfallLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsShortfallLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _shortfallAmountMeta = const VerificationMeta(
    'shortfallAmount',
  );
  @override
  late final GeneratedColumn<double> shortfallAmount = GeneratedColumn<double>(
    'shortfall_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _reasonTextMeta = const VerificationMeta(
    'reasonText',
  );
  @override
  late final GeneratedColumn<String> reasonText = GeneratedColumn<String>(
    'reason_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    shortfallAmount,
    reasonText,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_shortfall_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsShortfallLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('shortfall_amount')) {
      context.handle(
        _shortfallAmountMeta,
        shortfallAmount.isAcceptableOrUnknown(
          data['shortfall_amount']!,
          _shortfallAmountMeta,
        ),
      );
    }
    if (data.containsKey('reason_text')) {
      context.handle(
        _reasonTextMeta,
        reasonText.isAcceptableOrUnknown(data['reason_text']!, _reasonTextMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsShortfallLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsShortfallLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      shortfallAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}shortfall_amount'],
      )!,
      reasonText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_text'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavingsShortfallLogsTable createAlias(String alias) {
    return $SavingsShortfallLogsTable(attachedDatabase, alias);
  }
}

class SavingsShortfallLog extends DataClass
    implements Insertable<SavingsShortfallLog> {
  final int id;
  final int cycleId;
  final double shortfallAmount;
  final String reasonText;
  final DateTime updatedAt;
  const SavingsShortfallLog({
    required this.id,
    required this.cycleId,
    required this.shortfallAmount,
    required this.reasonText,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['shortfall_amount'] = Variable<double>(shortfallAmount);
    map['reason_text'] = Variable<String>(reasonText);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SavingsShortfallLogsCompanion toCompanion(bool nullToAbsent) {
    return SavingsShortfallLogsCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      shortfallAmount: Value(shortfallAmount),
      reasonText: Value(reasonText),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavingsShortfallLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsShortfallLog(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      shortfallAmount: serializer.fromJson<double>(json['shortfallAmount']),
      reasonText: serializer.fromJson<String>(json['reasonText']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'shortfallAmount': serializer.toJson<double>(shortfallAmount),
      'reasonText': serializer.toJson<String>(reasonText),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SavingsShortfallLog copyWith({
    int? id,
    int? cycleId,
    double? shortfallAmount,
    String? reasonText,
    DateTime? updatedAt,
  }) => SavingsShortfallLog(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    shortfallAmount: shortfallAmount ?? this.shortfallAmount,
    reasonText: reasonText ?? this.reasonText,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavingsShortfallLog copyWithCompanion(SavingsShortfallLogsCompanion data) {
    return SavingsShortfallLog(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      shortfallAmount: data.shortfallAmount.present
          ? data.shortfallAmount.value
          : this.shortfallAmount,
      reasonText: data.reasonText.present
          ? data.reasonText.value
          : this.reasonText,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsShortfallLog(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('shortfallAmount: $shortfallAmount, ')
          ..write('reasonText: $reasonText, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cycleId, shortfallAmount, reasonText, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsShortfallLog &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.shortfallAmount == this.shortfallAmount &&
          other.reasonText == this.reasonText &&
          other.updatedAt == this.updatedAt);
}

class SavingsShortfallLogsCompanion
    extends UpdateCompanion<SavingsShortfallLog> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<double> shortfallAmount;
  final Value<String> reasonText;
  final Value<DateTime> updatedAt;
  const SavingsShortfallLogsCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.shortfallAmount = const Value.absent(),
    this.reasonText = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SavingsShortfallLogsCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    this.shortfallAmount = const Value.absent(),
    this.reasonText = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : cycleId = Value(cycleId);
  static Insertable<SavingsShortfallLog> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<double>? shortfallAmount,
    Expression<String>? reasonText,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (shortfallAmount != null) 'shortfall_amount': shortfallAmount,
      if (reasonText != null) 'reason_text': reasonText,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SavingsShortfallLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<double>? shortfallAmount,
    Value<String>? reasonText,
    Value<DateTime>? updatedAt,
  }) {
    return SavingsShortfallLogsCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      shortfallAmount: shortfallAmount ?? this.shortfallAmount,
      reasonText: reasonText ?? this.reasonText,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (shortfallAmount.present) {
      map['shortfall_amount'] = Variable<double>(shortfallAmount.value);
    }
    if (reasonText.present) {
      map['reason_text'] = Variable<String>(reasonText.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsShortfallLogsCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('shortfallAmount: $shortfallAmount, ')
          ..write('reasonText: $reasonText, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MealModesTable extends MealModes
    with TableInfo<$MealModesTable, MealMode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealModesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  @override
  List<GeneratedColumn> get $columns => [id, name, isDefault];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_modes';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealMode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealMode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealMode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
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
    );
  }

  @override
  $MealModesTable createAlias(String alias) {
    return $MealModesTable(attachedDatabase, alias);
  }
}

class MealMode extends DataClass implements Insertable<MealMode> {
  final int id;
  final String name;
  final bool isDefault;
  const MealMode({
    required this.id,
    required this.name,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  MealModesCompanion toCompanion(bool nullToAbsent) {
    return MealModesCompanion(
      id: Value(id),
      name: Value(name),
      isDefault: Value(isDefault),
    );
  }

  factory MealMode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealMode(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  MealMode copyWith({int? id, String? name, bool? isDefault}) => MealMode(
    id: id ?? this.id,
    name: name ?? this.name,
    isDefault: isDefault ?? this.isDefault,
  );
  MealMode copyWithCompanion(MealModesCompanion data) {
    return MealMode(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealMode(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealMode &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDefault == this.isDefault);
}

class MealModesCompanion extends UpdateCompanion<MealMode> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDefault;
  const MealModesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDefault = const Value.absent(),
  });
  MealModesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDefault = const Value.absent(),
  }) : name = Value(name);
  static Insertable<MealMode> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  MealModesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isDefault,
  }) {
    return MealModesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealModesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }
}

class $MealScheduleEntriesTable extends MealScheduleEntries
    with TableInfo<$MealScheduleEntriesTable, MealScheduleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealScheduleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modeIdMeta = const VerificationMeta('modeId');
  @override
  late final GeneratedColumn<int> modeId = GeneratedColumn<int>(
    'mode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealSlotMeta = const VerificationMeta(
    'mealSlot',
  );
  @override
  late final GeneratedColumn<String> mealSlot = GeneratedColumn<String>(
    'meal_slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modeId,
    dayOfWeek,
    mealSlot,
    amount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_schedule_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealScheduleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mode_id')) {
      context.handle(
        _modeIdMeta,
        modeId.isAcceptableOrUnknown(data['mode_id']!, _modeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modeIdMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('meal_slot')) {
      context.handle(
        _mealSlotMeta,
        mealSlot.isAcceptableOrUnknown(data['meal_slot']!, _mealSlotMeta),
      );
    } else if (isInserting) {
      context.missing(_mealSlotMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {modeId, dayOfWeek, mealSlot},
  ];
  @override
  MealScheduleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealScheduleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      modeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode_id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      mealSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_slot'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
    );
  }

  @override
  $MealScheduleEntriesTable createAlias(String alias) {
    return $MealScheduleEntriesTable(attachedDatabase, alias);
  }
}

class MealScheduleEntry extends DataClass
    implements Insertable<MealScheduleEntry> {
  final int id;
  final int modeId;

  /// 1 = Monday .. 7 = Sunday
  final int dayOfWeek;

  /// 'breakfast', 'lunch', 'dinner'
  final String mealSlot;

  /// Nullable: null indicates skipped ('—') slot evaluating to 0
  final double? amount;
  const MealScheduleEntry({
    required this.id,
    required this.modeId,
    required this.dayOfWeek,
    required this.mealSlot,
    this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mode_id'] = Variable<int>(modeId);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['meal_slot'] = Variable<String>(mealSlot);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    return map;
  }

  MealScheduleEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealScheduleEntriesCompanion(
      id: Value(id),
      modeId: Value(modeId),
      dayOfWeek: Value(dayOfWeek),
      mealSlot: Value(mealSlot),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
    );
  }

  factory MealScheduleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealScheduleEntry(
      id: serializer.fromJson<int>(json['id']),
      modeId: serializer.fromJson<int>(json['modeId']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      mealSlot: serializer.fromJson<String>(json['mealSlot']),
      amount: serializer.fromJson<double?>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modeId': serializer.toJson<int>(modeId),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'mealSlot': serializer.toJson<String>(mealSlot),
      'amount': serializer.toJson<double?>(amount),
    };
  }

  MealScheduleEntry copyWith({
    int? id,
    int? modeId,
    int? dayOfWeek,
    String? mealSlot,
    Value<double?> amount = const Value.absent(),
  }) => MealScheduleEntry(
    id: id ?? this.id,
    modeId: modeId ?? this.modeId,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    mealSlot: mealSlot ?? this.mealSlot,
    amount: amount.present ? amount.value : this.amount,
  );
  MealScheduleEntry copyWithCompanion(MealScheduleEntriesCompanion data) {
    return MealScheduleEntry(
      id: data.id.present ? data.id.value : this.id,
      modeId: data.modeId.present ? data.modeId.value : this.modeId,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      mealSlot: data.mealSlot.present ? data.mealSlot.value : this.mealSlot,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealScheduleEntry(')
          ..write('id: $id, ')
          ..write('modeId: $modeId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, modeId, dayOfWeek, mealSlot, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealScheduleEntry &&
          other.id == this.id &&
          other.modeId == this.modeId &&
          other.dayOfWeek == this.dayOfWeek &&
          other.mealSlot == this.mealSlot &&
          other.amount == this.amount);
}

class MealScheduleEntriesCompanion extends UpdateCompanion<MealScheduleEntry> {
  final Value<int> id;
  final Value<int> modeId;
  final Value<int> dayOfWeek;
  final Value<String> mealSlot;
  final Value<double?> amount;
  const MealScheduleEntriesCompanion({
    this.id = const Value.absent(),
    this.modeId = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.mealSlot = const Value.absent(),
    this.amount = const Value.absent(),
  });
  MealScheduleEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int modeId,
    required int dayOfWeek,
    required String mealSlot,
    this.amount = const Value.absent(),
  }) : modeId = Value(modeId),
       dayOfWeek = Value(dayOfWeek),
       mealSlot = Value(mealSlot);
  static Insertable<MealScheduleEntry> custom({
    Expression<int>? id,
    Expression<int>? modeId,
    Expression<int>? dayOfWeek,
    Expression<String>? mealSlot,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeId != null) 'mode_id': modeId,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (mealSlot != null) 'meal_slot': mealSlot,
      if (amount != null) 'amount': amount,
    });
  }

  MealScheduleEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? modeId,
    Value<int>? dayOfWeek,
    Value<String>? mealSlot,
    Value<double?>? amount,
  }) {
    return MealScheduleEntriesCompanion(
      id: id ?? this.id,
      modeId: modeId ?? this.modeId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      mealSlot: mealSlot ?? this.mealSlot,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modeId.present) {
      map['mode_id'] = Variable<int>(modeId.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (mealSlot.present) {
      map['meal_slot'] = Variable<String>(mealSlot.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealScheduleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('modeId: $modeId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $WeeklyModeAssignmentsTable extends WeeklyModeAssignments
    with TableInfo<$WeeklyModeAssignmentsTable, WeeklyModeAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyModeAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekIndexMeta = const VerificationMeta(
    'weekIndex',
  );
  @override
  late final GeneratedColumn<int> weekIndex = GeneratedColumn<int>(
    'week_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeIdMeta = const VerificationMeta('modeId');
  @override
  late final GeneratedColumn<int> modeId = GeneratedColumn<int>(
    'mode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overrideTotalMeta = const VerificationMeta(
    'overrideTotal',
  );
  @override
  late final GeneratedColumn<double> overrideTotal = GeneratedColumn<double>(
    'override_total',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    weekIndex,
    modeId,
    overrideTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_mode_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyModeAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('week_index')) {
      context.handle(
        _weekIndexMeta,
        weekIndex.isAcceptableOrUnknown(data['week_index']!, _weekIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_weekIndexMeta);
    }
    if (data.containsKey('mode_id')) {
      context.handle(
        _modeIdMeta,
        modeId.isAcceptableOrUnknown(data['mode_id']!, _modeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modeIdMeta);
    }
    if (data.containsKey('override_total')) {
      context.handle(
        _overrideTotalMeta,
        overrideTotal.isAcceptableOrUnknown(
          data['override_total']!,
          _overrideTotalMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {cycleId, weekIndex},
  ];
  @override
  WeeklyModeAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyModeAssignment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      weekIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_index'],
      )!,
      modeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode_id'],
      )!,
      overrideTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}override_total'],
      ),
    );
  }

  @override
  $WeeklyModeAssignmentsTable createAlias(String alias) {
    return $WeeklyModeAssignmentsTable(attachedDatabase, alias);
  }
}

class WeeklyModeAssignment extends DataClass
    implements Insertable<WeeklyModeAssignment> {
  final int id;
  final int cycleId;
  final int weekIndex;
  final int modeId;
  final double? overrideTotal;
  const WeeklyModeAssignment({
    required this.id,
    required this.cycleId,
    required this.weekIndex,
    required this.modeId,
    this.overrideTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['week_index'] = Variable<int>(weekIndex);
    map['mode_id'] = Variable<int>(modeId);
    if (!nullToAbsent || overrideTotal != null) {
      map['override_total'] = Variable<double>(overrideTotal);
    }
    return map;
  }

  WeeklyModeAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyModeAssignmentsCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      weekIndex: Value(weekIndex),
      modeId: Value(modeId),
      overrideTotal: overrideTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(overrideTotal),
    );
  }

  factory WeeklyModeAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyModeAssignment(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      weekIndex: serializer.fromJson<int>(json['weekIndex']),
      modeId: serializer.fromJson<int>(json['modeId']),
      overrideTotal: serializer.fromJson<double?>(json['overrideTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'weekIndex': serializer.toJson<int>(weekIndex),
      'modeId': serializer.toJson<int>(modeId),
      'overrideTotal': serializer.toJson<double?>(overrideTotal),
    };
  }

  WeeklyModeAssignment copyWith({
    int? id,
    int? cycleId,
    int? weekIndex,
    int? modeId,
    Value<double?> overrideTotal = const Value.absent(),
  }) => WeeklyModeAssignment(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    weekIndex: weekIndex ?? this.weekIndex,
    modeId: modeId ?? this.modeId,
    overrideTotal: overrideTotal.present
        ? overrideTotal.value
        : this.overrideTotal,
  );
  WeeklyModeAssignment copyWithCompanion(WeeklyModeAssignmentsCompanion data) {
    return WeeklyModeAssignment(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      weekIndex: data.weekIndex.present ? data.weekIndex.value : this.weekIndex,
      modeId: data.modeId.present ? data.modeId.value : this.modeId,
      overrideTotal: data.overrideTotal.present
          ? data.overrideTotal.value
          : this.overrideTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyModeAssignment(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('modeId: $modeId, ')
          ..write('overrideTotal: $overrideTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cycleId, weekIndex, modeId, overrideTotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyModeAssignment &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.weekIndex == this.weekIndex &&
          other.modeId == this.modeId &&
          other.overrideTotal == this.overrideTotal);
}

class WeeklyModeAssignmentsCompanion
    extends UpdateCompanion<WeeklyModeAssignment> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<int> weekIndex;
  final Value<int> modeId;
  final Value<double?> overrideTotal;
  const WeeklyModeAssignmentsCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.weekIndex = const Value.absent(),
    this.modeId = const Value.absent(),
    this.overrideTotal = const Value.absent(),
  });
  WeeklyModeAssignmentsCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required int weekIndex,
    required int modeId,
    this.overrideTotal = const Value.absent(),
  }) : cycleId = Value(cycleId),
       weekIndex = Value(weekIndex),
       modeId = Value(modeId);
  static Insertable<WeeklyModeAssignment> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<int>? weekIndex,
    Expression<int>? modeId,
    Expression<double>? overrideTotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (weekIndex != null) 'week_index': weekIndex,
      if (modeId != null) 'mode_id': modeId,
      if (overrideTotal != null) 'override_total': overrideTotal,
    });
  }

  WeeklyModeAssignmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<int>? weekIndex,
    Value<int>? modeId,
    Value<double?>? overrideTotal,
  }) {
    return WeeklyModeAssignmentsCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      weekIndex: weekIndex ?? this.weekIndex,
      modeId: modeId ?? this.modeId,
      overrideTotal: overrideTotal ?? this.overrideTotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (weekIndex.present) {
      map['week_index'] = Variable<int>(weekIndex.value);
    }
    if (modeId.present) {
      map['mode_id'] = Variable<int>(modeId.value);
    }
    if (overrideTotal.present) {
      map['override_total'] = Variable<double>(overrideTotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyModeAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('modeId: $modeId, ')
          ..write('overrideTotal: $overrideTotal')
          ..write(')'))
        .toString();
  }
}

class $WeeklyMealOverridesTable extends WeeklyMealOverrides
    with TableInfo<$WeeklyMealOverridesTable, WeeklyMealOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyMealOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _assignmentIdMeta = const VerificationMeta(
    'assignmentId',
  );
  @override
  late final GeneratedColumn<int> assignmentId = GeneratedColumn<int>(
    'assignment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealSlotMeta = const VerificationMeta(
    'mealSlot',
  );
  @override
  late final GeneratedColumn<String> mealSlot = GeneratedColumn<String>(
    'meal_slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSkippedMeta = const VerificationMeta(
    'isSkipped',
  );
  @override
  late final GeneratedColumn<bool> isSkipped = GeneratedColumn<bool>(
    'is_skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assignmentId,
    dayOfWeek,
    mealSlot,
    amount,
    isSkipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_meal_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyMealOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('assignment_id')) {
      context.handle(
        _assignmentIdMeta,
        assignmentId.isAcceptableOrUnknown(
          data['assignment_id']!,
          _assignmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignmentIdMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('meal_slot')) {
      context.handle(
        _mealSlotMeta,
        mealSlot.isAcceptableOrUnknown(data['meal_slot']!, _mealSlotMeta),
      );
    } else if (isInserting) {
      context.missing(_mealSlotMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('is_skipped')) {
      context.handle(
        _isSkippedMeta,
        isSkipped.isAcceptableOrUnknown(data['is_skipped']!, _isSkippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {assignmentId, dayOfWeek, mealSlot},
  ];
  @override
  WeeklyMealOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyMealOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      assignmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assignment_id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      mealSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_slot'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      isSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_skipped'],
      )!,
    );
  }

  @override
  $WeeklyMealOverridesTable createAlias(String alias) {
    return $WeeklyMealOverridesTable(attachedDatabase, alias);
  }
}

class WeeklyMealOverride extends DataClass
    implements Insertable<WeeklyMealOverride> {
  final int id;
  final int assignmentId;
  final int dayOfWeek;
  final String mealSlot;
  final double? amount;
  final bool isSkipped;
  const WeeklyMealOverride({
    required this.id,
    required this.assignmentId,
    required this.dayOfWeek,
    required this.mealSlot,
    this.amount,
    required this.isSkipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['assignment_id'] = Variable<int>(assignmentId);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['meal_slot'] = Variable<String>(mealSlot);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    map['is_skipped'] = Variable<bool>(isSkipped);
    return map;
  }

  WeeklyMealOverridesCompanion toCompanion(bool nullToAbsent) {
    return WeeklyMealOverridesCompanion(
      id: Value(id),
      assignmentId: Value(assignmentId),
      dayOfWeek: Value(dayOfWeek),
      mealSlot: Value(mealSlot),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      isSkipped: Value(isSkipped),
    );
  }

  factory WeeklyMealOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyMealOverride(
      id: serializer.fromJson<int>(json['id']),
      assignmentId: serializer.fromJson<int>(json['assignmentId']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      mealSlot: serializer.fromJson<String>(json['mealSlot']),
      amount: serializer.fromJson<double?>(json['amount']),
      isSkipped: serializer.fromJson<bool>(json['isSkipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assignmentId': serializer.toJson<int>(assignmentId),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'mealSlot': serializer.toJson<String>(mealSlot),
      'amount': serializer.toJson<double?>(amount),
      'isSkipped': serializer.toJson<bool>(isSkipped),
    };
  }

  WeeklyMealOverride copyWith({
    int? id,
    int? assignmentId,
    int? dayOfWeek,
    String? mealSlot,
    Value<double?> amount = const Value.absent(),
    bool? isSkipped,
  }) => WeeklyMealOverride(
    id: id ?? this.id,
    assignmentId: assignmentId ?? this.assignmentId,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    mealSlot: mealSlot ?? this.mealSlot,
    amount: amount.present ? amount.value : this.amount,
    isSkipped: isSkipped ?? this.isSkipped,
  );
  WeeklyMealOverride copyWithCompanion(WeeklyMealOverridesCompanion data) {
    return WeeklyMealOverride(
      id: data.id.present ? data.id.value : this.id,
      assignmentId: data.assignmentId.present
          ? data.assignmentId.value
          : this.assignmentId,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      mealSlot: data.mealSlot.present ? data.mealSlot.value : this.mealSlot,
      amount: data.amount.present ? data.amount.value : this.amount,
      isSkipped: data.isSkipped.present ? data.isSkipped.value : this.isSkipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyMealOverride(')
          ..write('id: $id, ')
          ..write('assignmentId: $assignmentId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('amount: $amount, ')
          ..write('isSkipped: $isSkipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, assignmentId, dayOfWeek, mealSlot, amount, isSkipped);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyMealOverride &&
          other.id == this.id &&
          other.assignmentId == this.assignmentId &&
          other.dayOfWeek == this.dayOfWeek &&
          other.mealSlot == this.mealSlot &&
          other.amount == this.amount &&
          other.isSkipped == this.isSkipped);
}

class WeeklyMealOverridesCompanion extends UpdateCompanion<WeeklyMealOverride> {
  final Value<int> id;
  final Value<int> assignmentId;
  final Value<int> dayOfWeek;
  final Value<String> mealSlot;
  final Value<double?> amount;
  final Value<bool> isSkipped;
  const WeeklyMealOverridesCompanion({
    this.id = const Value.absent(),
    this.assignmentId = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.mealSlot = const Value.absent(),
    this.amount = const Value.absent(),
    this.isSkipped = const Value.absent(),
  });
  WeeklyMealOverridesCompanion.insert({
    this.id = const Value.absent(),
    required int assignmentId,
    required int dayOfWeek,
    required String mealSlot,
    this.amount = const Value.absent(),
    this.isSkipped = const Value.absent(),
  }) : assignmentId = Value(assignmentId),
       dayOfWeek = Value(dayOfWeek),
       mealSlot = Value(mealSlot);
  static Insertable<WeeklyMealOverride> custom({
    Expression<int>? id,
    Expression<int>? assignmentId,
    Expression<int>? dayOfWeek,
    Expression<String>? mealSlot,
    Expression<double>? amount,
    Expression<bool>? isSkipped,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assignmentId != null) 'assignment_id': assignmentId,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (mealSlot != null) 'meal_slot': mealSlot,
      if (amount != null) 'amount': amount,
      if (isSkipped != null) 'is_skipped': isSkipped,
    });
  }

  WeeklyMealOverridesCompanion copyWith({
    Value<int>? id,
    Value<int>? assignmentId,
    Value<int>? dayOfWeek,
    Value<String>? mealSlot,
    Value<double?>? amount,
    Value<bool>? isSkipped,
  }) {
    return WeeklyMealOverridesCompanion(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      mealSlot: mealSlot ?? this.mealSlot,
      amount: amount ?? this.amount,
      isSkipped: isSkipped ?? this.isSkipped,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assignmentId.present) {
      map['assignment_id'] = Variable<int>(assignmentId.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (mealSlot.present) {
      map['meal_slot'] = Variable<String>(mealSlot.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isSkipped.present) {
      map['is_skipped'] = Variable<bool>(isSkipped.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyMealOverridesCompanion(')
          ..write('id: $id, ')
          ..write('assignmentId: $assignmentId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('amount: $amount, ')
          ..write('isSkipped: $isSkipped')
          ..write(')'))
        .toString();
  }
}

class $DefaultCategoryTemplatesTable extends DefaultCategoryTemplates
    with TableInfo<$DefaultCategoryTemplatesTable, DefaultCategoryTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefaultCategoryTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryTypeMeta = const VerificationMeta(
    'categoryType',
  );
  @override
  late final GeneratedColumn<String> categoryType = GeneratedColumn<String>(
    'category_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _defaultAllocatedMeta = const VerificationMeta(
    'defaultAllocated',
  );
  @override
  late final GeneratedColumn<double> defaultAllocated = GeneratedColumn<double>(
    'default_allocated',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryType,
    name,
    defaultAllocated,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'default_category_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DefaultCategoryTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_type')) {
      context.handle(
        _categoryTypeMeta,
        categoryType.isAcceptableOrUnknown(
          data['category_type']!,
          _categoryTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_allocated')) {
      context.handle(
        _defaultAllocatedMeta,
        defaultAllocated.isAcceptableOrUnknown(
          data['default_allocated']!,
          _defaultAllocatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultAllocatedMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DefaultCategoryTemplate map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DefaultCategoryTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultAllocated: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_allocated'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DefaultCategoryTemplatesTable createAlias(String alias) {
    return $DefaultCategoryTemplatesTable(attachedDatabase, alias);
  }
}

class DefaultCategoryTemplate extends DataClass
    implements Insertable<DefaultCategoryTemplate> {
  final int id;
  final String categoryType;
  final String name;
  final double defaultAllocated;
  final int sortOrder;
  const DefaultCategoryTemplate({
    required this.id,
    required this.categoryType,
    required this.name,
    required this.defaultAllocated,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_type'] = Variable<String>(categoryType);
    map['name'] = Variable<String>(name);
    map['default_allocated'] = Variable<double>(defaultAllocated);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DefaultCategoryTemplatesCompanion toCompanion(bool nullToAbsent) {
    return DefaultCategoryTemplatesCompanion(
      id: Value(id),
      categoryType: Value(categoryType),
      name: Value(name),
      defaultAllocated: Value(defaultAllocated),
      sortOrder: Value(sortOrder),
    );
  }

  factory DefaultCategoryTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DefaultCategoryTemplate(
      id: serializer.fromJson<int>(json['id']),
      categoryType: serializer.fromJson<String>(json['categoryType']),
      name: serializer.fromJson<String>(json['name']),
      defaultAllocated: serializer.fromJson<double>(json['defaultAllocated']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryType': serializer.toJson<String>(categoryType),
      'name': serializer.toJson<String>(name),
      'defaultAllocated': serializer.toJson<double>(defaultAllocated),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DefaultCategoryTemplate copyWith({
    int? id,
    String? categoryType,
    String? name,
    double? defaultAllocated,
    int? sortOrder,
  }) => DefaultCategoryTemplate(
    id: id ?? this.id,
    categoryType: categoryType ?? this.categoryType,
    name: name ?? this.name,
    defaultAllocated: defaultAllocated ?? this.defaultAllocated,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DefaultCategoryTemplate copyWithCompanion(
    DefaultCategoryTemplatesCompanion data,
  ) {
    return DefaultCategoryTemplate(
      id: data.id.present ? data.id.value : this.id,
      categoryType: data.categoryType.present
          ? data.categoryType.value
          : this.categoryType,
      name: data.name.present ? data.name.value : this.name,
      defaultAllocated: data.defaultAllocated.present
          ? data.defaultAllocated.value
          : this.defaultAllocated,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DefaultCategoryTemplate(')
          ..write('id: $id, ')
          ..write('categoryType: $categoryType, ')
          ..write('name: $name, ')
          ..write('defaultAllocated: $defaultAllocated, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryType, name, defaultAllocated, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DefaultCategoryTemplate &&
          other.id == this.id &&
          other.categoryType == this.categoryType &&
          other.name == this.name &&
          other.defaultAllocated == this.defaultAllocated &&
          other.sortOrder == this.sortOrder);
}

class DefaultCategoryTemplatesCompanion
    extends UpdateCompanion<DefaultCategoryTemplate> {
  final Value<int> id;
  final Value<String> categoryType;
  final Value<String> name;
  final Value<double> defaultAllocated;
  final Value<int> sortOrder;
  const DefaultCategoryTemplatesCompanion({
    this.id = const Value.absent(),
    this.categoryType = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultAllocated = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  DefaultCategoryTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String categoryType,
    required String name,
    required double defaultAllocated,
    required int sortOrder,
  }) : categoryType = Value(categoryType),
       name = Value(name),
       defaultAllocated = Value(defaultAllocated),
       sortOrder = Value(sortOrder);
  static Insertable<DefaultCategoryTemplate> custom({
    Expression<int>? id,
    Expression<String>? categoryType,
    Expression<String>? name,
    Expression<double>? defaultAllocated,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryType != null) 'category_type': categoryType,
      if (name != null) 'name': name,
      if (defaultAllocated != null) 'default_allocated': defaultAllocated,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  DefaultCategoryTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? categoryType,
    Value<String>? name,
    Value<double>? defaultAllocated,
    Value<int>? sortOrder,
  }) {
    return DefaultCategoryTemplatesCompanion(
      id: id ?? this.id,
      categoryType: categoryType ?? this.categoryType,
      name: name ?? this.name,
      defaultAllocated: defaultAllocated ?? this.defaultAllocated,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryType.present) {
      map['category_type'] = Variable<String>(categoryType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultAllocated.present) {
      map['default_allocated'] = Variable<double>(defaultAllocated.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefaultCategoryTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('categoryType: $categoryType, ')
          ..write('name: $name, ')
          ..write('defaultAllocated: $defaultAllocated, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $DefaultSubsectionTemplatesTable extends DefaultSubsectionTemplates
    with
        TableInfo<$DefaultSubsectionTemplatesTable, DefaultSubsectionTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefaultSubsectionTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryTypeMeta = const VerificationMeta(
    'categoryType',
  );
  @override
  late final GeneratedColumn<String> categoryType = GeneratedColumn<String>(
    'category_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentTemplateIdMeta = const VerificationMeta(
    'parentTemplateId',
  );
  @override
  late final GeneratedColumn<int> parentTemplateId = GeneratedColumn<int>(
    'parent_template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _defaultAllocatedMeta = const VerificationMeta(
    'defaultAllocated',
  );
  @override
  late final GeneratedColumn<double> defaultAllocated = GeneratedColumn<double>(
    'default_allocated',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isFoodLinkedMeta = const VerificationMeta(
    'isFoodLinked',
  );
  @override
  late final GeneratedColumn<bool> isFoodLinked = GeneratedColumn<bool>(
    'is_food_linked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_food_linked" IN (0, 1))',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryType,
    parentTemplateId,
    name,
    defaultAllocated,
    isFoodLinked,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'default_subsection_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DefaultSubsectionTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_type')) {
      context.handle(
        _categoryTypeMeta,
        categoryType.isAcceptableOrUnknown(
          data['category_type']!,
          _categoryTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryTypeMeta);
    }
    if (data.containsKey('parent_template_id')) {
      context.handle(
        _parentTemplateIdMeta,
        parentTemplateId.isAcceptableOrUnknown(
          data['parent_template_id']!,
          _parentTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_allocated')) {
      context.handle(
        _defaultAllocatedMeta,
        defaultAllocated.isAcceptableOrUnknown(
          data['default_allocated']!,
          _defaultAllocatedMeta,
        ),
      );
    }
    if (data.containsKey('is_food_linked')) {
      context.handle(
        _isFoodLinkedMeta,
        isFoodLinked.isAcceptableOrUnknown(
          data['is_food_linked']!,
          _isFoodLinkedMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DefaultSubsectionTemplate map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DefaultSubsectionTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_type'],
      )!,
      parentTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_template_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultAllocated: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_allocated'],
      )!,
      isFoodLinked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_food_linked'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DefaultSubsectionTemplatesTable createAlias(String alias) {
    return $DefaultSubsectionTemplatesTable(attachedDatabase, alias);
  }
}

class DefaultSubsectionTemplate extends DataClass
    implements Insertable<DefaultSubsectionTemplate> {
  final int id;
  final String categoryType;
  final int? parentTemplateId;
  final String name;
  final double defaultAllocated;
  final bool isFoodLinked;
  final int sortOrder;
  const DefaultSubsectionTemplate({
    required this.id,
    required this.categoryType,
    this.parentTemplateId,
    required this.name,
    required this.defaultAllocated,
    required this.isFoodLinked,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_type'] = Variable<String>(categoryType);
    if (!nullToAbsent || parentTemplateId != null) {
      map['parent_template_id'] = Variable<int>(parentTemplateId);
    }
    map['name'] = Variable<String>(name);
    map['default_allocated'] = Variable<double>(defaultAllocated);
    map['is_food_linked'] = Variable<bool>(isFoodLinked);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DefaultSubsectionTemplatesCompanion toCompanion(bool nullToAbsent) {
    return DefaultSubsectionTemplatesCompanion(
      id: Value(id),
      categoryType: Value(categoryType),
      parentTemplateId: parentTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTemplateId),
      name: Value(name),
      defaultAllocated: Value(defaultAllocated),
      isFoodLinked: Value(isFoodLinked),
      sortOrder: Value(sortOrder),
    );
  }

  factory DefaultSubsectionTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DefaultSubsectionTemplate(
      id: serializer.fromJson<int>(json['id']),
      categoryType: serializer.fromJson<String>(json['categoryType']),
      parentTemplateId: serializer.fromJson<int?>(json['parentTemplateId']),
      name: serializer.fromJson<String>(json['name']),
      defaultAllocated: serializer.fromJson<double>(json['defaultAllocated']),
      isFoodLinked: serializer.fromJson<bool>(json['isFoodLinked']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryType': serializer.toJson<String>(categoryType),
      'parentTemplateId': serializer.toJson<int?>(parentTemplateId),
      'name': serializer.toJson<String>(name),
      'defaultAllocated': serializer.toJson<double>(defaultAllocated),
      'isFoodLinked': serializer.toJson<bool>(isFoodLinked),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DefaultSubsectionTemplate copyWith({
    int? id,
    String? categoryType,
    Value<int?> parentTemplateId = const Value.absent(),
    String? name,
    double? defaultAllocated,
    bool? isFoodLinked,
    int? sortOrder,
  }) => DefaultSubsectionTemplate(
    id: id ?? this.id,
    categoryType: categoryType ?? this.categoryType,
    parentTemplateId: parentTemplateId.present
        ? parentTemplateId.value
        : this.parentTemplateId,
    name: name ?? this.name,
    defaultAllocated: defaultAllocated ?? this.defaultAllocated,
    isFoodLinked: isFoodLinked ?? this.isFoodLinked,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DefaultSubsectionTemplate copyWithCompanion(
    DefaultSubsectionTemplatesCompanion data,
  ) {
    return DefaultSubsectionTemplate(
      id: data.id.present ? data.id.value : this.id,
      categoryType: data.categoryType.present
          ? data.categoryType.value
          : this.categoryType,
      parentTemplateId: data.parentTemplateId.present
          ? data.parentTemplateId.value
          : this.parentTemplateId,
      name: data.name.present ? data.name.value : this.name,
      defaultAllocated: data.defaultAllocated.present
          ? data.defaultAllocated.value
          : this.defaultAllocated,
      isFoodLinked: data.isFoodLinked.present
          ? data.isFoodLinked.value
          : this.isFoodLinked,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DefaultSubsectionTemplate(')
          ..write('id: $id, ')
          ..write('categoryType: $categoryType, ')
          ..write('parentTemplateId: $parentTemplateId, ')
          ..write('name: $name, ')
          ..write('defaultAllocated: $defaultAllocated, ')
          ..write('isFoodLinked: $isFoodLinked, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryType,
    parentTemplateId,
    name,
    defaultAllocated,
    isFoodLinked,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DefaultSubsectionTemplate &&
          other.id == this.id &&
          other.categoryType == this.categoryType &&
          other.parentTemplateId == this.parentTemplateId &&
          other.name == this.name &&
          other.defaultAllocated == this.defaultAllocated &&
          other.isFoodLinked == this.isFoodLinked &&
          other.sortOrder == this.sortOrder);
}

class DefaultSubsectionTemplatesCompanion
    extends UpdateCompanion<DefaultSubsectionTemplate> {
  final Value<int> id;
  final Value<String> categoryType;
  final Value<int?> parentTemplateId;
  final Value<String> name;
  final Value<double> defaultAllocated;
  final Value<bool> isFoodLinked;
  final Value<int> sortOrder;
  const DefaultSubsectionTemplatesCompanion({
    this.id = const Value.absent(),
    this.categoryType = const Value.absent(),
    this.parentTemplateId = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultAllocated = const Value.absent(),
    this.isFoodLinked = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  DefaultSubsectionTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String categoryType,
    this.parentTemplateId = const Value.absent(),
    required String name,
    this.defaultAllocated = const Value.absent(),
    this.isFoodLinked = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : categoryType = Value(categoryType),
       name = Value(name);
  static Insertable<DefaultSubsectionTemplate> custom({
    Expression<int>? id,
    Expression<String>? categoryType,
    Expression<int>? parentTemplateId,
    Expression<String>? name,
    Expression<double>? defaultAllocated,
    Expression<bool>? isFoodLinked,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryType != null) 'category_type': categoryType,
      if (parentTemplateId != null) 'parent_template_id': parentTemplateId,
      if (name != null) 'name': name,
      if (defaultAllocated != null) 'default_allocated': defaultAllocated,
      if (isFoodLinked != null) 'is_food_linked': isFoodLinked,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  DefaultSubsectionTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? categoryType,
    Value<int?>? parentTemplateId,
    Value<String>? name,
    Value<double>? defaultAllocated,
    Value<bool>? isFoodLinked,
    Value<int>? sortOrder,
  }) {
    return DefaultSubsectionTemplatesCompanion(
      id: id ?? this.id,
      categoryType: categoryType ?? this.categoryType,
      parentTemplateId: parentTemplateId ?? this.parentTemplateId,
      name: name ?? this.name,
      defaultAllocated: defaultAllocated ?? this.defaultAllocated,
      isFoodLinked: isFoodLinked ?? this.isFoodLinked,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryType.present) {
      map['category_type'] = Variable<String>(categoryType.value);
    }
    if (parentTemplateId.present) {
      map['parent_template_id'] = Variable<int>(parentTemplateId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultAllocated.present) {
      map['default_allocated'] = Variable<double>(defaultAllocated.value);
    }
    if (isFoodLinked.present) {
      map['is_food_linked'] = Variable<bool>(isFoodLinked.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefaultSubsectionTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('categoryType: $categoryType, ')
          ..write('parentTemplateId: $parentTemplateId, ')
          ..write('name: $name, ')
          ..write('defaultAllocated: $defaultAllocated, ')
          ..write('isFoodLinked: $isFoodLinked, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BudgetCyclesTable budgetCycles = $BudgetCyclesTable(this);
  late final $SupplementaryIncomesTable supplementaryIncomes =
      $SupplementaryIncomesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SubsectionsTable subsections = $SubsectionsTable(this);
  late final $SubsectionEntriesTable subsectionEntries =
      $SubsectionEntriesTable(this);
  late final $SavingsShortfallLogsTable savingsShortfallLogs =
      $SavingsShortfallLogsTable(this);
  late final $MealModesTable mealModes = $MealModesTable(this);
  late final $MealScheduleEntriesTable mealScheduleEntries =
      $MealScheduleEntriesTable(this);
  late final $WeeklyModeAssignmentsTable weeklyModeAssignments =
      $WeeklyModeAssignmentsTable(this);
  late final $WeeklyMealOverridesTable weeklyMealOverrides =
      $WeeklyMealOverridesTable(this);
  late final $DefaultCategoryTemplatesTable defaultCategoryTemplates =
      $DefaultCategoryTemplatesTable(this);
  late final $DefaultSubsectionTemplatesTable defaultSubsectionTemplates =
      $DefaultSubsectionTemplatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    budgetCycles,
    supplementaryIncomes,
    categories,
    subsections,
    subsectionEntries,
    savingsShortfallLogs,
    mealModes,
    mealScheduleEntries,
    weeklyModeAssignments,
    weeklyMealOverrides,
    defaultCategoryTemplates,
    defaultSubsectionTemplates,
  ];
}

typedef $$BudgetCyclesTableCreateCompanionBuilder =
    BudgetCyclesCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      Value<int> configuredStartDay,
      Value<double> salaryAmount,
      Value<bool> isClosed,
      Value<DateTime> createdAt,
      Value<DateTime?> closedAt,
    });
typedef $$BudgetCyclesTableUpdateCompanionBuilder =
    BudgetCyclesCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> configuredStartDay,
      Value<double> salaryAmount,
      Value<bool> isClosed,
      Value<DateTime> createdAt,
      Value<DateTime?> closedAt,
    });

class $$BudgetCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get configuredStartDay => $composableBuilder(
    column: $table.configuredStartDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salaryAmount => $composableBuilder(
    column: $table.salaryAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get configuredStartDay => $composableBuilder(
    column: $table.configuredStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salaryAmount => $composableBuilder(
    column: $table.salaryAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get configuredStartDay => $composableBuilder(
    column: $table.configuredStartDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get salaryAmount => $composableBuilder(
    column: $table.salaryAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);
}

class $$BudgetCyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetCyclesTable,
          BudgetCycle,
          $$BudgetCyclesTableFilterComposer,
          $$BudgetCyclesTableOrderingComposer,
          $$BudgetCyclesTableAnnotationComposer,
          $$BudgetCyclesTableCreateCompanionBuilder,
          $$BudgetCyclesTableUpdateCompanionBuilder,
          (
            BudgetCycle,
            BaseReferences<_$AppDatabase, $BudgetCyclesTable, BudgetCycle>,
          ),
          BudgetCycle,
          PrefetchHooks Function()
        > {
  $$BudgetCyclesTableTableManager(_$AppDatabase db, $BudgetCyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> configuredStartDay = const Value.absent(),
                Value<double> salaryAmount = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
              }) => BudgetCyclesCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                configuredStartDay: configuredStartDay,
                salaryAmount: salaryAmount,
                isClosed: isClosed,
                createdAt: createdAt,
                closedAt: closedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                Value<int> configuredStartDay = const Value.absent(),
                Value<double> salaryAmount = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
              }) => BudgetCyclesCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                configuredStartDay: configuredStartDay,
                salaryAmount: salaryAmount,
                isClosed: isClosed,
                createdAt: createdAt,
                closedAt: closedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetCyclesTable,
      BudgetCycle,
      $$BudgetCyclesTableFilterComposer,
      $$BudgetCyclesTableOrderingComposer,
      $$BudgetCyclesTableAnnotationComposer,
      $$BudgetCyclesTableCreateCompanionBuilder,
      $$BudgetCyclesTableUpdateCompanionBuilder,
      (
        BudgetCycle,
        BaseReferences<_$AppDatabase, $BudgetCyclesTable, BudgetCycle>,
      ),
      BudgetCycle,
      PrefetchHooks Function()
    >;
typedef $$SupplementaryIncomesTableCreateCompanionBuilder =
    SupplementaryIncomesCompanion Function({
      Value<int> id,
      required int cycleId,
      required String label,
      required double amount,
      Value<DateTime> createdAt,
    });
typedef $$SupplementaryIncomesTableUpdateCompanionBuilder =
    SupplementaryIncomesCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<String> label,
      Value<double> amount,
      Value<DateTime> createdAt,
    });

class $$SupplementaryIncomesTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementaryIncomesTable> {
  $$SupplementaryIncomesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplementaryIncomesTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementaryIncomesTable> {
  $$SupplementaryIncomesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementaryIncomesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementaryIncomesTable> {
  $$SupplementaryIncomesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SupplementaryIncomesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementaryIncomesTable,
          SupplementaryIncome,
          $$SupplementaryIncomesTableFilterComposer,
          $$SupplementaryIncomesTableOrderingComposer,
          $$SupplementaryIncomesTableAnnotationComposer,
          $$SupplementaryIncomesTableCreateCompanionBuilder,
          $$SupplementaryIncomesTableUpdateCompanionBuilder,
          (
            SupplementaryIncome,
            BaseReferences<
              _$AppDatabase,
              $SupplementaryIncomesTable,
              SupplementaryIncome
            >,
          ),
          SupplementaryIncome,
          PrefetchHooks Function()
        > {
  $$SupplementaryIncomesTableTableManager(
    _$AppDatabase db,
    $SupplementaryIncomesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementaryIncomesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementaryIncomesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SupplementaryIncomesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SupplementaryIncomesCompanion(
                id: id,
                cycleId: cycleId,
                label: label,
                amount: amount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required String label,
                required double amount,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SupplementaryIncomesCompanion.insert(
                id: id,
                cycleId: cycleId,
                label: label,
                amount: amount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplementaryIncomesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementaryIncomesTable,
      SupplementaryIncome,
      $$SupplementaryIncomesTableFilterComposer,
      $$SupplementaryIncomesTableOrderingComposer,
      $$SupplementaryIncomesTableAnnotationComposer,
      $$SupplementaryIncomesTableCreateCompanionBuilder,
      $$SupplementaryIncomesTableUpdateCompanionBuilder,
      (
        SupplementaryIncome,
        BaseReferences<
          _$AppDatabase,
          $SupplementaryIncomesTable,
          SupplementaryIncome
        >,
      ),
      SupplementaryIncome,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required int cycleId,
      required String name,
      required String categoryType,
      Value<double> allocatedAmount,
      Value<int> sortOrder,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<String> name,
      Value<String> categoryType,
      Value<double> allocatedAmount,
      Value<int> sortOrder,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categoryType = const Value.absent(),
                Value<double> allocatedAmount = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                cycleId: cycleId,
                name: name,
                categoryType: categoryType,
                allocatedAmount: allocatedAmount,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required String name,
                required String categoryType,
                Value<double> allocatedAmount = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                cycleId: cycleId,
                name: name,
                categoryType: categoryType,
                allocatedAmount: allocatedAmount,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$SubsectionsTableCreateCompanionBuilder =
    SubsectionsCompanion Function({
      Value<int> id,
      required int categoryId,
      Value<int?> parentId,
      required String name,
      Value<double> allocatedAmount,
      Value<double> actualAmount,
      Value<bool> isFoodLinked,
      Value<int> sortOrder,
    });
typedef $$SubsectionsTableUpdateCompanionBuilder =
    SubsectionsCompanion Function({
      Value<int> id,
      Value<int> categoryId,
      Value<int?> parentId,
      Value<String> name,
      Value<double> allocatedAmount,
      Value<double> actualAmount,
      Value<bool> isFoodLinked,
      Value<int> sortOrder,
    });

class $$SubsectionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubsectionsTable> {
  $$SubsectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFoodLinked => $composableBuilder(
    column: $table.isFoodLinked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubsectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubsectionsTable> {
  $$SubsectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFoodLinked => $composableBuilder(
    column: $table.isFoodLinked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubsectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubsectionsTable> {
  $$SubsectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFoodLinked => $composableBuilder(
    column: $table.isFoodLinked,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SubsectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubsectionsTable,
          Subsection,
          $$SubsectionsTableFilterComposer,
          $$SubsectionsTableOrderingComposer,
          $$SubsectionsTableAnnotationComposer,
          $$SubsectionsTableCreateCompanionBuilder,
          $$SubsectionsTableUpdateCompanionBuilder,
          (
            Subsection,
            BaseReferences<_$AppDatabase, $SubsectionsTable, Subsection>,
          ),
          Subsection,
          PrefetchHooks Function()
        > {
  $$SubsectionsTableTableManager(_$AppDatabase db, $SubsectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubsectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubsectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubsectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> allocatedAmount = const Value.absent(),
                Value<double> actualAmount = const Value.absent(),
                Value<bool> isFoodLinked = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => SubsectionsCompanion(
                id: id,
                categoryId: categoryId,
                parentId: parentId,
                name: name,
                allocatedAmount: allocatedAmount,
                actualAmount: actualAmount,
                isFoodLinked: isFoodLinked,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                Value<int?> parentId = const Value.absent(),
                required String name,
                Value<double> allocatedAmount = const Value.absent(),
                Value<double> actualAmount = const Value.absent(),
                Value<bool> isFoodLinked = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => SubsectionsCompanion.insert(
                id: id,
                categoryId: categoryId,
                parentId: parentId,
                name: name,
                allocatedAmount: allocatedAmount,
                actualAmount: actualAmount,
                isFoodLinked: isFoodLinked,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubsectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubsectionsTable,
      Subsection,
      $$SubsectionsTableFilterComposer,
      $$SubsectionsTableOrderingComposer,
      $$SubsectionsTableAnnotationComposer,
      $$SubsectionsTableCreateCompanionBuilder,
      $$SubsectionsTableUpdateCompanionBuilder,
      (
        Subsection,
        BaseReferences<_$AppDatabase, $SubsectionsTable, Subsection>,
      ),
      Subsection,
      PrefetchHooks Function()
    >;
typedef $$SubsectionEntriesTableCreateCompanionBuilder =
    SubsectionEntriesCompanion Function({
      Value<int> id,
      required int subsectionId,
      required double amount,
      Value<String> note,
      Value<DateTime> entryDate,
    });
typedef $$SubsectionEntriesTableUpdateCompanionBuilder =
    SubsectionEntriesCompanion Function({
      Value<int> id,
      Value<int> subsectionId,
      Value<double> amount,
      Value<String> note,
      Value<DateTime> entryDate,
    });

class $$SubsectionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SubsectionEntriesTable> {
  $$SubsectionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subsectionId => $composableBuilder(
    column: $table.subsectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubsectionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubsectionEntriesTable> {
  $$SubsectionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subsectionId => $composableBuilder(
    column: $table.subsectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubsectionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubsectionEntriesTable> {
  $$SubsectionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get subsectionId => $composableBuilder(
    column: $table.subsectionId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);
}

class $$SubsectionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubsectionEntriesTable,
          SubsectionEntry,
          $$SubsectionEntriesTableFilterComposer,
          $$SubsectionEntriesTableOrderingComposer,
          $$SubsectionEntriesTableAnnotationComposer,
          $$SubsectionEntriesTableCreateCompanionBuilder,
          $$SubsectionEntriesTableUpdateCompanionBuilder,
          (
            SubsectionEntry,
            BaseReferences<
              _$AppDatabase,
              $SubsectionEntriesTable,
              SubsectionEntry
            >,
          ),
          SubsectionEntry,
          PrefetchHooks Function()
        > {
  $$SubsectionEntriesTableTableManager(
    _$AppDatabase db,
    $SubsectionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubsectionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubsectionEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubsectionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subsectionId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
              }) => SubsectionEntriesCompanion(
                id: id,
                subsectionId: subsectionId,
                amount: amount,
                note: note,
                entryDate: entryDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subsectionId,
                required double amount,
                Value<String> note = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
              }) => SubsectionEntriesCompanion.insert(
                id: id,
                subsectionId: subsectionId,
                amount: amount,
                note: note,
                entryDate: entryDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubsectionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubsectionEntriesTable,
      SubsectionEntry,
      $$SubsectionEntriesTableFilterComposer,
      $$SubsectionEntriesTableOrderingComposer,
      $$SubsectionEntriesTableAnnotationComposer,
      $$SubsectionEntriesTableCreateCompanionBuilder,
      $$SubsectionEntriesTableUpdateCompanionBuilder,
      (
        SubsectionEntry,
        BaseReferences<_$AppDatabase, $SubsectionEntriesTable, SubsectionEntry>,
      ),
      SubsectionEntry,
      PrefetchHooks Function()
    >;
typedef $$SavingsShortfallLogsTableCreateCompanionBuilder =
    SavingsShortfallLogsCompanion Function({
      Value<int> id,
      required int cycleId,
      Value<double> shortfallAmount,
      Value<String> reasonText,
      Value<DateTime> updatedAt,
    });
typedef $$SavingsShortfallLogsTableUpdateCompanionBuilder =
    SavingsShortfallLogsCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<double> shortfallAmount,
      Value<String> reasonText,
      Value<DateTime> updatedAt,
    });

class $$SavingsShortfallLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsShortfallLogsTable> {
  $$SavingsShortfallLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get shortfallAmount => $composableBuilder(
    column: $table.shortfallAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsShortfallLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsShortfallLogsTable> {
  $$SavingsShortfallLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get shortfallAmount => $composableBuilder(
    column: $table.shortfallAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsShortfallLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsShortfallLogsTable> {
  $$SavingsShortfallLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<double> get shortfallAmount => $composableBuilder(
    column: $table.shortfallAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SavingsShortfallLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsShortfallLogsTable,
          SavingsShortfallLog,
          $$SavingsShortfallLogsTableFilterComposer,
          $$SavingsShortfallLogsTableOrderingComposer,
          $$SavingsShortfallLogsTableAnnotationComposer,
          $$SavingsShortfallLogsTableCreateCompanionBuilder,
          $$SavingsShortfallLogsTableUpdateCompanionBuilder,
          (
            SavingsShortfallLog,
            BaseReferences<
              _$AppDatabase,
              $SavingsShortfallLogsTable,
              SavingsShortfallLog
            >,
          ),
          SavingsShortfallLog,
          PrefetchHooks Function()
        > {
  $$SavingsShortfallLogsTableTableManager(
    _$AppDatabase db,
    $SavingsShortfallLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsShortfallLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsShortfallLogsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SavingsShortfallLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<double> shortfallAmount = const Value.absent(),
                Value<String> reasonText = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsShortfallLogsCompanion(
                id: id,
                cycleId: cycleId,
                shortfallAmount: shortfallAmount,
                reasonText: reasonText,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                Value<double> shortfallAmount = const Value.absent(),
                Value<String> reasonText = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsShortfallLogsCompanion.insert(
                id: id,
                cycleId: cycleId,
                shortfallAmount: shortfallAmount,
                reasonText: reasonText,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsShortfallLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsShortfallLogsTable,
      SavingsShortfallLog,
      $$SavingsShortfallLogsTableFilterComposer,
      $$SavingsShortfallLogsTableOrderingComposer,
      $$SavingsShortfallLogsTableAnnotationComposer,
      $$SavingsShortfallLogsTableCreateCompanionBuilder,
      $$SavingsShortfallLogsTableUpdateCompanionBuilder,
      (
        SavingsShortfallLog,
        BaseReferences<
          _$AppDatabase,
          $SavingsShortfallLogsTable,
          SavingsShortfallLog
        >,
      ),
      SavingsShortfallLog,
      PrefetchHooks Function()
    >;
typedef $$MealModesTableCreateCompanionBuilder =
    MealModesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isDefault,
    });
typedef $$MealModesTableUpdateCompanionBuilder =
    MealModesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isDefault,
    });

class $$MealModesTableFilterComposer
    extends Composer<_$AppDatabase, $MealModesTable> {
  $$MealModesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
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
}

class $$MealModesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealModesTable> {
  $$MealModesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
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
}

class $$MealModesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealModesTable> {
  $$MealModesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);
}

class $$MealModesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealModesTable,
          MealMode,
          $$MealModesTableFilterComposer,
          $$MealModesTableOrderingComposer,
          $$MealModesTableAnnotationComposer,
          $$MealModesTableCreateCompanionBuilder,
          $$MealModesTableUpdateCompanionBuilder,
          (MealMode, BaseReferences<_$AppDatabase, $MealModesTable, MealMode>),
          MealMode,
          PrefetchHooks Function()
        > {
  $$MealModesTableTableManager(_$AppDatabase db, $MealModesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealModesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealModesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealModesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
              }) =>
                  MealModesCompanion(id: id, name: name, isDefault: isDefault),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isDefault = const Value.absent(),
              }) => MealModesCompanion.insert(
                id: id,
                name: name,
                isDefault: isDefault,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealModesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealModesTable,
      MealMode,
      $$MealModesTableFilterComposer,
      $$MealModesTableOrderingComposer,
      $$MealModesTableAnnotationComposer,
      $$MealModesTableCreateCompanionBuilder,
      $$MealModesTableUpdateCompanionBuilder,
      (MealMode, BaseReferences<_$AppDatabase, $MealModesTable, MealMode>),
      MealMode,
      PrefetchHooks Function()
    >;
typedef $$MealScheduleEntriesTableCreateCompanionBuilder =
    MealScheduleEntriesCompanion Function({
      Value<int> id,
      required int modeId,
      required int dayOfWeek,
      required String mealSlot,
      Value<double?> amount,
    });
typedef $$MealScheduleEntriesTableUpdateCompanionBuilder =
    MealScheduleEntriesCompanion Function({
      Value<int> id,
      Value<int> modeId,
      Value<int> dayOfWeek,
      Value<String> mealSlot,
      Value<double?> amount,
    });

class $$MealScheduleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MealScheduleEntriesTable> {
  $$MealScheduleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modeId => $composableBuilder(
    column: $table.modeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealSlot => $composableBuilder(
    column: $table.mealSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealScheduleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealScheduleEntriesTable> {
  $$MealScheduleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modeId => $composableBuilder(
    column: $table.modeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealSlot => $composableBuilder(
    column: $table.mealSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealScheduleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealScheduleEntriesTable> {
  $$MealScheduleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get modeId =>
      $composableBuilder(column: $table.modeId, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get mealSlot =>
      $composableBuilder(column: $table.mealSlot, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);
}

class $$MealScheduleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealScheduleEntriesTable,
          MealScheduleEntry,
          $$MealScheduleEntriesTableFilterComposer,
          $$MealScheduleEntriesTableOrderingComposer,
          $$MealScheduleEntriesTableAnnotationComposer,
          $$MealScheduleEntriesTableCreateCompanionBuilder,
          $$MealScheduleEntriesTableUpdateCompanionBuilder,
          (
            MealScheduleEntry,
            BaseReferences<
              _$AppDatabase,
              $MealScheduleEntriesTable,
              MealScheduleEntry
            >,
          ),
          MealScheduleEntry,
          PrefetchHooks Function()
        > {
  $$MealScheduleEntriesTableTableManager(
    _$AppDatabase db,
    $MealScheduleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealScheduleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealScheduleEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MealScheduleEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> modeId = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<String> mealSlot = const Value.absent(),
                Value<double?> amount = const Value.absent(),
              }) => MealScheduleEntriesCompanion(
                id: id,
                modeId: modeId,
                dayOfWeek: dayOfWeek,
                mealSlot: mealSlot,
                amount: amount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int modeId,
                required int dayOfWeek,
                required String mealSlot,
                Value<double?> amount = const Value.absent(),
              }) => MealScheduleEntriesCompanion.insert(
                id: id,
                modeId: modeId,
                dayOfWeek: dayOfWeek,
                mealSlot: mealSlot,
                amount: amount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealScheduleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealScheduleEntriesTable,
      MealScheduleEntry,
      $$MealScheduleEntriesTableFilterComposer,
      $$MealScheduleEntriesTableOrderingComposer,
      $$MealScheduleEntriesTableAnnotationComposer,
      $$MealScheduleEntriesTableCreateCompanionBuilder,
      $$MealScheduleEntriesTableUpdateCompanionBuilder,
      (
        MealScheduleEntry,
        BaseReferences<
          _$AppDatabase,
          $MealScheduleEntriesTable,
          MealScheduleEntry
        >,
      ),
      MealScheduleEntry,
      PrefetchHooks Function()
    >;
typedef $$WeeklyModeAssignmentsTableCreateCompanionBuilder =
    WeeklyModeAssignmentsCompanion Function({
      Value<int> id,
      required int cycleId,
      required int weekIndex,
      required int modeId,
      Value<double?> overrideTotal,
    });
typedef $$WeeklyModeAssignmentsTableUpdateCompanionBuilder =
    WeeklyModeAssignmentsCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<int> weekIndex,
      Value<int> modeId,
      Value<double?> overrideTotal,
    });

class $$WeeklyModeAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyModeAssignmentsTable> {
  $$WeeklyModeAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modeId => $composableBuilder(
    column: $table.modeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overrideTotal => $composableBuilder(
    column: $table.overrideTotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyModeAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyModeAssignmentsTable> {
  $$WeeklyModeAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modeId => $composableBuilder(
    column: $table.modeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overrideTotal => $composableBuilder(
    column: $table.overrideTotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyModeAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyModeAssignmentsTable> {
  $$WeeklyModeAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<int> get weekIndex =>
      $composableBuilder(column: $table.weekIndex, builder: (column) => column);

  GeneratedColumn<int> get modeId =>
      $composableBuilder(column: $table.modeId, builder: (column) => column);

  GeneratedColumn<double> get overrideTotal => $composableBuilder(
    column: $table.overrideTotal,
    builder: (column) => column,
  );
}

class $$WeeklyModeAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyModeAssignmentsTable,
          WeeklyModeAssignment,
          $$WeeklyModeAssignmentsTableFilterComposer,
          $$WeeklyModeAssignmentsTableOrderingComposer,
          $$WeeklyModeAssignmentsTableAnnotationComposer,
          $$WeeklyModeAssignmentsTableCreateCompanionBuilder,
          $$WeeklyModeAssignmentsTableUpdateCompanionBuilder,
          (
            WeeklyModeAssignment,
            BaseReferences<
              _$AppDatabase,
              $WeeklyModeAssignmentsTable,
              WeeklyModeAssignment
            >,
          ),
          WeeklyModeAssignment,
          PrefetchHooks Function()
        > {
  $$WeeklyModeAssignmentsTableTableManager(
    _$AppDatabase db,
    $WeeklyModeAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyModeAssignmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WeeklyModeAssignmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeeklyModeAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<int> weekIndex = const Value.absent(),
                Value<int> modeId = const Value.absent(),
                Value<double?> overrideTotal = const Value.absent(),
              }) => WeeklyModeAssignmentsCompanion(
                id: id,
                cycleId: cycleId,
                weekIndex: weekIndex,
                modeId: modeId,
                overrideTotal: overrideTotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required int weekIndex,
                required int modeId,
                Value<double?> overrideTotal = const Value.absent(),
              }) => WeeklyModeAssignmentsCompanion.insert(
                id: id,
                cycleId: cycleId,
                weekIndex: weekIndex,
                modeId: modeId,
                overrideTotal: overrideTotal,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyModeAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyModeAssignmentsTable,
      WeeklyModeAssignment,
      $$WeeklyModeAssignmentsTableFilterComposer,
      $$WeeklyModeAssignmentsTableOrderingComposer,
      $$WeeklyModeAssignmentsTableAnnotationComposer,
      $$WeeklyModeAssignmentsTableCreateCompanionBuilder,
      $$WeeklyModeAssignmentsTableUpdateCompanionBuilder,
      (
        WeeklyModeAssignment,
        BaseReferences<
          _$AppDatabase,
          $WeeklyModeAssignmentsTable,
          WeeklyModeAssignment
        >,
      ),
      WeeklyModeAssignment,
      PrefetchHooks Function()
    >;
typedef $$WeeklyMealOverridesTableCreateCompanionBuilder =
    WeeklyMealOverridesCompanion Function({
      Value<int> id,
      required int assignmentId,
      required int dayOfWeek,
      required String mealSlot,
      Value<double?> amount,
      Value<bool> isSkipped,
    });
typedef $$WeeklyMealOverridesTableUpdateCompanionBuilder =
    WeeklyMealOverridesCompanion Function({
      Value<int> id,
      Value<int> assignmentId,
      Value<int> dayOfWeek,
      Value<String> mealSlot,
      Value<double?> amount,
      Value<bool> isSkipped,
    });

class $$WeeklyMealOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyMealOverridesTable> {
  $$WeeklyMealOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealSlot => $composableBuilder(
    column: $table.mealSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyMealOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyMealOverridesTable> {
  $$WeeklyMealOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealSlot => $composableBuilder(
    column: $table.mealSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyMealOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyMealOverridesTable> {
  $$WeeklyMealOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get mealSlot =>
      $composableBuilder(column: $table.mealSlot, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get isSkipped =>
      $composableBuilder(column: $table.isSkipped, builder: (column) => column);
}

class $$WeeklyMealOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyMealOverridesTable,
          WeeklyMealOverride,
          $$WeeklyMealOverridesTableFilterComposer,
          $$WeeklyMealOverridesTableOrderingComposer,
          $$WeeklyMealOverridesTableAnnotationComposer,
          $$WeeklyMealOverridesTableCreateCompanionBuilder,
          $$WeeklyMealOverridesTableUpdateCompanionBuilder,
          (
            WeeklyMealOverride,
            BaseReferences<
              _$AppDatabase,
              $WeeklyMealOverridesTable,
              WeeklyMealOverride
            >,
          ),
          WeeklyMealOverride,
          PrefetchHooks Function()
        > {
  $$WeeklyMealOverridesTableTableManager(
    _$AppDatabase db,
    $WeeklyMealOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyMealOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyMealOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeeklyMealOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> assignmentId = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<String> mealSlot = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
              }) => WeeklyMealOverridesCompanion(
                id: id,
                assignmentId: assignmentId,
                dayOfWeek: dayOfWeek,
                mealSlot: mealSlot,
                amount: amount,
                isSkipped: isSkipped,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int assignmentId,
                required int dayOfWeek,
                required String mealSlot,
                Value<double?> amount = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
              }) => WeeklyMealOverridesCompanion.insert(
                id: id,
                assignmentId: assignmentId,
                dayOfWeek: dayOfWeek,
                mealSlot: mealSlot,
                amount: amount,
                isSkipped: isSkipped,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyMealOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyMealOverridesTable,
      WeeklyMealOverride,
      $$WeeklyMealOverridesTableFilterComposer,
      $$WeeklyMealOverridesTableOrderingComposer,
      $$WeeklyMealOverridesTableAnnotationComposer,
      $$WeeklyMealOverridesTableCreateCompanionBuilder,
      $$WeeklyMealOverridesTableUpdateCompanionBuilder,
      (
        WeeklyMealOverride,
        BaseReferences<
          _$AppDatabase,
          $WeeklyMealOverridesTable,
          WeeklyMealOverride
        >,
      ),
      WeeklyMealOverride,
      PrefetchHooks Function()
    >;
typedef $$DefaultCategoryTemplatesTableCreateCompanionBuilder =
    DefaultCategoryTemplatesCompanion Function({
      Value<int> id,
      required String categoryType,
      required String name,
      required double defaultAllocated,
      required int sortOrder,
    });
typedef $$DefaultCategoryTemplatesTableUpdateCompanionBuilder =
    DefaultCategoryTemplatesCompanion Function({
      Value<int> id,
      Value<String> categoryType,
      Value<String> name,
      Value<double> defaultAllocated,
      Value<int> sortOrder,
    });

class $$DefaultCategoryTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $DefaultCategoryTemplatesTable> {
  $$DefaultCategoryTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultAllocated => $composableBuilder(
    column: $table.defaultAllocated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DefaultCategoryTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $DefaultCategoryTemplatesTable> {
  $$DefaultCategoryTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultAllocated => $composableBuilder(
    column: $table.defaultAllocated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DefaultCategoryTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefaultCategoryTemplatesTable> {
  $$DefaultCategoryTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get defaultAllocated => $composableBuilder(
    column: $table.defaultAllocated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DefaultCategoryTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DefaultCategoryTemplatesTable,
          DefaultCategoryTemplate,
          $$DefaultCategoryTemplatesTableFilterComposer,
          $$DefaultCategoryTemplatesTableOrderingComposer,
          $$DefaultCategoryTemplatesTableAnnotationComposer,
          $$DefaultCategoryTemplatesTableCreateCompanionBuilder,
          $$DefaultCategoryTemplatesTableUpdateCompanionBuilder,
          (
            DefaultCategoryTemplate,
            BaseReferences<
              _$AppDatabase,
              $DefaultCategoryTemplatesTable,
              DefaultCategoryTemplate
            >,
          ),
          DefaultCategoryTemplate,
          PrefetchHooks Function()
        > {
  $$DefaultCategoryTemplatesTableTableManager(
    _$AppDatabase db,
    $DefaultCategoryTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefaultCategoryTemplatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DefaultCategoryTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DefaultCategoryTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoryType = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> defaultAllocated = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => DefaultCategoryTemplatesCompanion(
                id: id,
                categoryType: categoryType,
                name: name,
                defaultAllocated: defaultAllocated,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoryType,
                required String name,
                required double defaultAllocated,
                required int sortOrder,
              }) => DefaultCategoryTemplatesCompanion.insert(
                id: id,
                categoryType: categoryType,
                name: name,
                defaultAllocated: defaultAllocated,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DefaultCategoryTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DefaultCategoryTemplatesTable,
      DefaultCategoryTemplate,
      $$DefaultCategoryTemplatesTableFilterComposer,
      $$DefaultCategoryTemplatesTableOrderingComposer,
      $$DefaultCategoryTemplatesTableAnnotationComposer,
      $$DefaultCategoryTemplatesTableCreateCompanionBuilder,
      $$DefaultCategoryTemplatesTableUpdateCompanionBuilder,
      (
        DefaultCategoryTemplate,
        BaseReferences<
          _$AppDatabase,
          $DefaultCategoryTemplatesTable,
          DefaultCategoryTemplate
        >,
      ),
      DefaultCategoryTemplate,
      PrefetchHooks Function()
    >;
typedef $$DefaultSubsectionTemplatesTableCreateCompanionBuilder =
    DefaultSubsectionTemplatesCompanion Function({
      Value<int> id,
      required String categoryType,
      Value<int?> parentTemplateId,
      required String name,
      Value<double> defaultAllocated,
      Value<bool> isFoodLinked,
      Value<int> sortOrder,
    });
typedef $$DefaultSubsectionTemplatesTableUpdateCompanionBuilder =
    DefaultSubsectionTemplatesCompanion Function({
      Value<int> id,
      Value<String> categoryType,
      Value<int?> parentTemplateId,
      Value<String> name,
      Value<double> defaultAllocated,
      Value<bool> isFoodLinked,
      Value<int> sortOrder,
    });

class $$DefaultSubsectionTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $DefaultSubsectionTemplatesTable> {
  $$DefaultSubsectionTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentTemplateId => $composableBuilder(
    column: $table.parentTemplateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultAllocated => $composableBuilder(
    column: $table.defaultAllocated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFoodLinked => $composableBuilder(
    column: $table.isFoodLinked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DefaultSubsectionTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $DefaultSubsectionTemplatesTable> {
  $$DefaultSubsectionTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentTemplateId => $composableBuilder(
    column: $table.parentTemplateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultAllocated => $composableBuilder(
    column: $table.defaultAllocated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFoodLinked => $composableBuilder(
    column: $table.isFoodLinked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DefaultSubsectionTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefaultSubsectionTemplatesTable> {
  $$DefaultSubsectionTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentTemplateId => $composableBuilder(
    column: $table.parentTemplateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get defaultAllocated => $composableBuilder(
    column: $table.defaultAllocated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFoodLinked => $composableBuilder(
    column: $table.isFoodLinked,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DefaultSubsectionTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DefaultSubsectionTemplatesTable,
          DefaultSubsectionTemplate,
          $$DefaultSubsectionTemplatesTableFilterComposer,
          $$DefaultSubsectionTemplatesTableOrderingComposer,
          $$DefaultSubsectionTemplatesTableAnnotationComposer,
          $$DefaultSubsectionTemplatesTableCreateCompanionBuilder,
          $$DefaultSubsectionTemplatesTableUpdateCompanionBuilder,
          (
            DefaultSubsectionTemplate,
            BaseReferences<
              _$AppDatabase,
              $DefaultSubsectionTemplatesTable,
              DefaultSubsectionTemplate
            >,
          ),
          DefaultSubsectionTemplate,
          PrefetchHooks Function()
        > {
  $$DefaultSubsectionTemplatesTableTableManager(
    _$AppDatabase db,
    $DefaultSubsectionTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefaultSubsectionTemplatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DefaultSubsectionTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DefaultSubsectionTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoryType = const Value.absent(),
                Value<int?> parentTemplateId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> defaultAllocated = const Value.absent(),
                Value<bool> isFoodLinked = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => DefaultSubsectionTemplatesCompanion(
                id: id,
                categoryType: categoryType,
                parentTemplateId: parentTemplateId,
                name: name,
                defaultAllocated: defaultAllocated,
                isFoodLinked: isFoodLinked,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoryType,
                Value<int?> parentTemplateId = const Value.absent(),
                required String name,
                Value<double> defaultAllocated = const Value.absent(),
                Value<bool> isFoodLinked = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => DefaultSubsectionTemplatesCompanion.insert(
                id: id,
                categoryType: categoryType,
                parentTemplateId: parentTemplateId,
                name: name,
                defaultAllocated: defaultAllocated,
                isFoodLinked: isFoodLinked,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DefaultSubsectionTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DefaultSubsectionTemplatesTable,
      DefaultSubsectionTemplate,
      $$DefaultSubsectionTemplatesTableFilterComposer,
      $$DefaultSubsectionTemplatesTableOrderingComposer,
      $$DefaultSubsectionTemplatesTableAnnotationComposer,
      $$DefaultSubsectionTemplatesTableCreateCompanionBuilder,
      $$DefaultSubsectionTemplatesTableUpdateCompanionBuilder,
      (
        DefaultSubsectionTemplate,
        BaseReferences<
          _$AppDatabase,
          $DefaultSubsectionTemplatesTable,
          DefaultSubsectionTemplate
        >,
      ),
      DefaultSubsectionTemplate,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BudgetCyclesTableTableManager get budgetCycles =>
      $$BudgetCyclesTableTableManager(_db, _db.budgetCycles);
  $$SupplementaryIncomesTableTableManager get supplementaryIncomes =>
      $$SupplementaryIncomesTableTableManager(_db, _db.supplementaryIncomes);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SubsectionsTableTableManager get subsections =>
      $$SubsectionsTableTableManager(_db, _db.subsections);
  $$SubsectionEntriesTableTableManager get subsectionEntries =>
      $$SubsectionEntriesTableTableManager(_db, _db.subsectionEntries);
  $$SavingsShortfallLogsTableTableManager get savingsShortfallLogs =>
      $$SavingsShortfallLogsTableTableManager(_db, _db.savingsShortfallLogs);
  $$MealModesTableTableManager get mealModes =>
      $$MealModesTableTableManager(_db, _db.mealModes);
  $$MealScheduleEntriesTableTableManager get mealScheduleEntries =>
      $$MealScheduleEntriesTableTableManager(_db, _db.mealScheduleEntries);
  $$WeeklyModeAssignmentsTableTableManager get weeklyModeAssignments =>
      $$WeeklyModeAssignmentsTableTableManager(_db, _db.weeklyModeAssignments);
  $$WeeklyMealOverridesTableTableManager get weeklyMealOverrides =>
      $$WeeklyMealOverridesTableTableManager(_db, _db.weeklyMealOverrides);
  $$DefaultCategoryTemplatesTableTableManager get defaultCategoryTemplates =>
      $$DefaultCategoryTemplatesTableTableManager(
        _db,
        _db.defaultCategoryTemplates,
      );
  $$DefaultSubsectionTemplatesTableTableManager
  get defaultSubsectionTemplates =>
      $$DefaultSubsectionTemplatesTableTableManager(
        _db,
        _db.defaultSubsectionTemplates,
      );
}
