// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScheduleItemCollection on Isar {
  IsarCollection<ScheduleItem> get scheduleItems => this.collection();
}

const ScheduleItemSchema = CollectionSchema(
  name: r'ScheduleItem',
  id: 1124194671555598070,
  properties: {
    r'colorInHex': PropertySchema(
      id: 0,
      name: r'colorInHex',
      type: IsarType.string,
    ),
    r'eventName': PropertySchema(
      id: 1,
      name: r'eventName',
      type: IsarType.string,
    ),
    r'fromInMill': PropertySchema(
      id: 2,
      name: r'fromInMill',
      type: IsarType.long,
    ),
    r'isAllDay': PropertySchema(
      id: 3,
      name: r'isAllDay',
      type: IsarType.bool,
    ),
    r'toInMill': PropertySchema(
      id: 4,
      name: r'toInMill',
      type: IsarType.long,
    )
  },
  estimateSize: _scheduleItemEstimateSize,
  serialize: _scheduleItemSerialize,
  deserialize: _scheduleItemDeserialize,
  deserializeProp: _scheduleItemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _scheduleItemGetId,
  getLinks: _scheduleItemGetLinks,
  attach: _scheduleItemAttach,
  version: '3.1.0+1',
);

int _scheduleItemEstimateSize(
  ScheduleItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.colorInHex.length * 3;
  bytesCount += 3 + object.eventName.length * 3;
  return bytesCount;
}

void _scheduleItemSerialize(
  ScheduleItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.colorInHex);
  writer.writeString(offsets[1], object.eventName);
  writer.writeLong(offsets[2], object.fromInMill);
  writer.writeBool(offsets[3], object.isAllDay);
  writer.writeLong(offsets[4], object.toInMill);
}

ScheduleItem _scheduleItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScheduleItem();
  object.colorInHex = reader.readString(offsets[0]);
  object.eventName = reader.readString(offsets[1]);
  object.fromInMill = reader.readLong(offsets[2]);
  object.id = id;
  object.isAllDay = reader.readBool(offsets[3]);
  object.toInMill = reader.readLong(offsets[4]);
  return object;
}

P _scheduleItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scheduleItemGetId(ScheduleItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scheduleItemGetLinks(ScheduleItem object) {
  return [];
}

void _scheduleItemAttach(
    IsarCollection<dynamic> col, Id id, ScheduleItem object) {
  object.id = id;
}

extension ScheduleItemQueryWhereSort
    on QueryBuilder<ScheduleItem, ScheduleItem, QWhere> {
  QueryBuilder<ScheduleItem, ScheduleItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScheduleItemQueryWhere
    on QueryBuilder<ScheduleItem, ScheduleItem, QWhereClause> {
  QueryBuilder<ScheduleItem, ScheduleItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterWhereClause> idBetween(
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
}

extension ScheduleItemQueryFilter
    on QueryBuilder<ScheduleItem, ScheduleItem, QFilterCondition> {
  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorInHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorInHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorInHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorInHex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorInHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorInHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorInHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorInHex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorInHex',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      colorInHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorInHex',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      eventNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      fromInMillEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromInMill',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      fromInMillGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fromInMill',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      fromInMillLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fromInMill',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      fromInMillBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fromInMill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      isAllDayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAllDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      toInMillEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toInMill',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      toInMillGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toInMill',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      toInMillLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toInMill',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterFilterCondition>
      toInMillBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toInMill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScheduleItemQueryObject
    on QueryBuilder<ScheduleItem, ScheduleItem, QFilterCondition> {}

extension ScheduleItemQueryLinks
    on QueryBuilder<ScheduleItem, ScheduleItem, QFilterCondition> {}

extension ScheduleItemQuerySortBy
    on QueryBuilder<ScheduleItem, ScheduleItem, QSortBy> {
  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByColorInHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInHex', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy>
      sortByColorInHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInHex', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByEventName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventName', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByEventNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventName', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByFromInMill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromInMill', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy>
      sortByFromInMillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromInMill', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByIsAllDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAllDay', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByIsAllDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAllDay', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByToInMill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toInMill', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> sortByToInMillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toInMill', Sort.desc);
    });
  }
}

extension ScheduleItemQuerySortThenBy
    on QueryBuilder<ScheduleItem, ScheduleItem, QSortThenBy> {
  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByColorInHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInHex', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy>
      thenByColorInHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInHex', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByEventName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventName', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByEventNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventName', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByFromInMill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromInMill', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy>
      thenByFromInMillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromInMill', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByIsAllDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAllDay', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByIsAllDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAllDay', Sort.desc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByToInMill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toInMill', Sort.asc);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QAfterSortBy> thenByToInMillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toInMill', Sort.desc);
    });
  }
}

extension ScheduleItemQueryWhereDistinct
    on QueryBuilder<ScheduleItem, ScheduleItem, QDistinct> {
  QueryBuilder<ScheduleItem, ScheduleItem, QDistinct> distinctByColorInHex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorInHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QDistinct> distinctByEventName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QDistinct> distinctByFromInMill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fromInMill');
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QDistinct> distinctByIsAllDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAllDay');
    });
  }

  QueryBuilder<ScheduleItem, ScheduleItem, QDistinct> distinctByToInMill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toInMill');
    });
  }
}

extension ScheduleItemQueryProperty
    on QueryBuilder<ScheduleItem, ScheduleItem, QQueryProperty> {
  QueryBuilder<ScheduleItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScheduleItem, String, QQueryOperations> colorInHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorInHex');
    });
  }

  QueryBuilder<ScheduleItem, String, QQueryOperations> eventNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventName');
    });
  }

  QueryBuilder<ScheduleItem, int, QQueryOperations> fromInMillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fromInMill');
    });
  }

  QueryBuilder<ScheduleItem, bool, QQueryOperations> isAllDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAllDay');
    });
  }

  QueryBuilder<ScheduleItem, int, QQueryOperations> toInMillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toInMill');
    });
  }
}
