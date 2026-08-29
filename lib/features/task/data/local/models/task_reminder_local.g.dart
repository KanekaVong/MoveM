// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_reminder_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskReminderLocalCollection on Isar {
  IsarCollection<TaskReminderLocal> get taskReminderLocals => this.collection();
}

const TaskReminderLocalSchema = CollectionSchema(
  name: r'TaskReminderLocal',
  id: 4058721765078958821,
  properties: {
    r'activityId': PropertySchema(
      id: 0,
      name: r'activityId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isCancelled': PropertySchema(
      id: 2,
      name: r'isCancelled',
      type: IsarType.bool,
    ),
    r'isScheduled': PropertySchema(
      id: 3,
      name: r'isScheduled',
      type: IsarType.bool,
    ),
    r'isSent': PropertySchema(
      id: 4,
      name: r'isSent',
      type: IsarType.bool,
    ),
    r'remindAt': PropertySchema(
      id: 5,
      name: r'remindAt',
      type: IsarType.dateTime,
    ),
    r'reminderId': PropertySchema(
      id: 6,
      name: r'reminderId',
      type: IsarType.long,
    ),
    r'taskDescription': PropertySchema(
      id: 7,
      name: r'taskDescription',
      type: IsarType.string,
    ),
    r'taskTitle': PropertySchema(
      id: 8,
      name: r'taskTitle',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 9,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _taskReminderLocalEstimateSize,
  serialize: _taskReminderLocalSerialize,
  deserialize: _taskReminderLocalDeserialize,
  deserializeProp: _taskReminderLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'reminderId': IndexSchema(
      id: 3675930301236523255,
      name: r'reminderId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'reminderId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'activityId': IndexSchema(
      id: 8968520805042838249,
      name: r'activityId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'activityId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _taskReminderLocalGetId,
  getLinks: _taskReminderLocalGetLinks,
  attach: _taskReminderLocalAttach,
  version: '3.1.0+1',
);

int _taskReminderLocalEstimateSize(
  TaskReminderLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activityId.length * 3;
  {
    final value = object.taskDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.taskTitle.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _taskReminderLocalSerialize(
  TaskReminderLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activityId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.isCancelled);
  writer.writeBool(offsets[3], object.isScheduled);
  writer.writeBool(offsets[4], object.isSent);
  writer.writeDateTime(offsets[5], object.remindAt);
  writer.writeLong(offsets[6], object.reminderId);
  writer.writeString(offsets[7], object.taskDescription);
  writer.writeString(offsets[8], object.taskTitle);
  writer.writeString(offsets[9], object.type);
}

TaskReminderLocal _taskReminderLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskReminderLocal();
  object.activityId = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.isCancelled = reader.readBool(offsets[2]);
  object.isScheduled = reader.readBool(offsets[3]);
  object.isSent = reader.readBool(offsets[4]);
  object.remindAt = reader.readDateTime(offsets[5]);
  object.reminderId = reader.readLong(offsets[6]);
  object.taskDescription = reader.readStringOrNull(offsets[7]);
  object.taskTitle = reader.readString(offsets[8]);
  object.type = reader.readString(offsets[9]);
  return object;
}

P _taskReminderLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _taskReminderLocalGetId(TaskReminderLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskReminderLocalGetLinks(
    TaskReminderLocal object) {
  return [];
}

void _taskReminderLocalAttach(
    IsarCollection<dynamic> col, Id id, TaskReminderLocal object) {
  object.id = id;
}

extension TaskReminderLocalByIndex on IsarCollection<TaskReminderLocal> {
  Future<TaskReminderLocal?> getByReminderId(int reminderId) {
    return getByIndex(r'reminderId', [reminderId]);
  }

  TaskReminderLocal? getByReminderIdSync(int reminderId) {
    return getByIndexSync(r'reminderId', [reminderId]);
  }

  Future<bool> deleteByReminderId(int reminderId) {
    return deleteByIndex(r'reminderId', [reminderId]);
  }

  bool deleteByReminderIdSync(int reminderId) {
    return deleteByIndexSync(r'reminderId', [reminderId]);
  }

  Future<List<TaskReminderLocal?>> getAllByReminderId(
      List<int> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'reminderId', values);
  }

  List<TaskReminderLocal?> getAllByReminderIdSync(List<int> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'reminderId', values);
  }

  Future<int> deleteAllByReminderId(List<int> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'reminderId', values);
  }

  int deleteAllByReminderIdSync(List<int> reminderIdValues) {
    final values = reminderIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'reminderId', values);
  }

  Future<Id> putByReminderId(TaskReminderLocal object) {
    return putByIndex(r'reminderId', object);
  }

  Id putByReminderIdSync(TaskReminderLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'reminderId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReminderId(List<TaskReminderLocal> objects) {
    return putAllByIndex(r'reminderId', objects);
  }

  List<Id> putAllByReminderIdSync(List<TaskReminderLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reminderId', objects, saveLinks: saveLinks);
  }
}

extension TaskReminderLocalQueryWhereSort
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QWhere> {
  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhere>
      anyReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reminderId'),
      );
    });
  }
}

extension TaskReminderLocalQueryWhere
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QWhereClause> {
  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      reminderIdEqualTo(int reminderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reminderId',
        value: [reminderId],
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      reminderIdNotEqualTo(int reminderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [],
              upper: [reminderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [reminderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [reminderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [],
              upper: [reminderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      reminderIdGreaterThan(
    int reminderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reminderId',
        lower: [reminderId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      reminderIdLessThan(
    int reminderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reminderId',
        lower: [],
        upper: [reminderId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      reminderIdBetween(
    int lowerReminderId,
    int upperReminderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reminderId',
        lower: [lowerReminderId],
        includeLower: includeLower,
        upper: [upperReminderId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      activityIdEqualTo(String activityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'activityId',
        value: [activityId],
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterWhereClause>
      activityIdNotEqualTo(String activityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityId',
              lower: [],
              upper: [activityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityId',
              lower: [activityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityId',
              lower: [activityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityId',
              lower: [],
              upper: [activityId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TaskReminderLocalQueryFilter
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QFilterCondition> {
  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityId',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      activityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityId',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      isCancelledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCancelled',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      isScheduledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      isSentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSent',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      remindAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remindAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      remindAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remindAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      remindAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remindAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      remindAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remindAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      reminderIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      reminderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      reminderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      reminderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taskDescription',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taskDescription',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      taskTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension TaskReminderLocalQueryObject
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QFilterCondition> {}

extension TaskReminderLocalQueryLinks
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QFilterCondition> {}

extension TaskReminderLocalQuerySortBy
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QSortBy> {
  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByActivityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByActivityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByIsScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScheduled', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByIsScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScheduled', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByIsSent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByIsSentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByRemindAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindAt', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByRemindAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindAt', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByTaskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByTaskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TaskReminderLocalQuerySortThenBy
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QSortThenBy> {
  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByActivityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByActivityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByIsScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScheduled', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByIsScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScheduled', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByIsSent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByIsSentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByRemindAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindAt', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByRemindAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindAt', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByTaskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByTaskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TaskReminderLocalQueryWhereDistinct
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct> {
  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByActivityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCancelled');
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByIsScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isScheduled');
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByIsSent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSent');
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByRemindAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remindAt');
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderId');
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByTaskDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct>
      distinctByTaskTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskReminderLocal, TaskReminderLocal, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension TaskReminderLocalQueryProperty
    on QueryBuilder<TaskReminderLocal, TaskReminderLocal, QQueryProperty> {
  QueryBuilder<TaskReminderLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaskReminderLocal, String, QQueryOperations>
      activityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityId');
    });
  }

  QueryBuilder<TaskReminderLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TaskReminderLocal, bool, QQueryOperations>
      isCancelledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCancelled');
    });
  }

  QueryBuilder<TaskReminderLocal, bool, QQueryOperations>
      isScheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isScheduled');
    });
  }

  QueryBuilder<TaskReminderLocal, bool, QQueryOperations> isSentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSent');
    });
  }

  QueryBuilder<TaskReminderLocal, DateTime, QQueryOperations>
      remindAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remindAt');
    });
  }

  QueryBuilder<TaskReminderLocal, int, QQueryOperations> reminderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderId');
    });
  }

  QueryBuilder<TaskReminderLocal, String?, QQueryOperations>
      taskDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskDescription');
    });
  }

  QueryBuilder<TaskReminderLocal, String, QQueryOperations>
      taskTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskTitle');
    });
  }

  QueryBuilder<TaskReminderLocal, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
