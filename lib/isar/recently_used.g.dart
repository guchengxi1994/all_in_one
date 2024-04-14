// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_used.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentlyUsedCollection on Isar {
  IsarCollection<RecentlyUsed> get recentlyUseds => this.collection();
}

const RecentlyUsedSchema = CollectionSchema(
  name: r'RecentlyUsed',
  id: -1623128743834963530,
  properties: {
    r'createAt': PropertySchema(
      id: 0,
      name: r'createAt',
      type: IsarType.long,
    ),
    r'router': PropertySchema(
      id: 1,
      name: r'router',
      type: IsarType.string,
    ),
    r'toolName': PropertySchema(
      id: 2,
      name: r'toolName',
      type: IsarType.string,
    )
  },
  estimateSize: _recentlyUsedEstimateSize,
  serialize: _recentlyUsedSerialize,
  deserialize: _recentlyUsedDeserialize,
  deserializeProp: _recentlyUsedDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _recentlyUsedGetId,
  getLinks: _recentlyUsedGetLinks,
  attach: _recentlyUsedAttach,
  version: '3.1.0+1',
);

int _recentlyUsedEstimateSize(
  RecentlyUsed object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.router.length * 3;
  bytesCount += 3 + object.toolName.length * 3;
  return bytesCount;
}

void _recentlyUsedSerialize(
  RecentlyUsed object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.createAt);
  writer.writeString(offsets[1], object.router);
  writer.writeString(offsets[2], object.toolName);
}

RecentlyUsed _recentlyUsedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentlyUsed();
  object.createAt = reader.readLong(offsets[0]);
  object.id = id;
  object.router = reader.readString(offsets[1]);
  object.toolName = reader.readString(offsets[2]);
  return object;
}

P _recentlyUsedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentlyUsedGetId(RecentlyUsed object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentlyUsedGetLinks(RecentlyUsed object) {
  return [];
}

void _recentlyUsedAttach(
    IsarCollection<dynamic> col, Id id, RecentlyUsed object) {
  object.id = id;
}

extension RecentlyUsedQueryWhereSort
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QWhere> {
  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecentlyUsedQueryWhere
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QWhereClause> {
  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterWhereClause> idBetween(
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

extension RecentlyUsedQueryFilter
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QFilterCondition> {
  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      createAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      createAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      createAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      createAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition> routerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'router',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      routerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'router',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      routerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'router',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition> routerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'router',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      routerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'router',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      routerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'router',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      routerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'router',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition> routerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'router',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      routerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'router',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      routerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'router',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toolName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'toolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'toolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'toolName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'toolName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toolName',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterFilterCondition>
      toolNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'toolName',
        value: '',
      ));
    });
  }
}

extension RecentlyUsedQueryObject
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QFilterCondition> {}

extension RecentlyUsedQueryLinks
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QFilterCondition> {}

extension RecentlyUsedQuerySortBy
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QSortBy> {
  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> sortByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> sortByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> sortByRouter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'router', Sort.asc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> sortByRouterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'router', Sort.desc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> sortByToolName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toolName', Sort.asc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> sortByToolNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toolName', Sort.desc);
    });
  }
}

extension RecentlyUsedQuerySortThenBy
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QSortThenBy> {
  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenByRouter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'router', Sort.asc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenByRouterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'router', Sort.desc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenByToolName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toolName', Sort.asc);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QAfterSortBy> thenByToolNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toolName', Sort.desc);
    });
  }
}

extension RecentlyUsedQueryWhereDistinct
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QDistinct> {
  QueryBuilder<RecentlyUsed, RecentlyUsed, QDistinct> distinctByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createAt');
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QDistinct> distinctByRouter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'router', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyUsed, RecentlyUsed, QDistinct> distinctByToolName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toolName', caseSensitive: caseSensitive);
    });
  }
}

extension RecentlyUsedQueryProperty
    on QueryBuilder<RecentlyUsed, RecentlyUsed, QQueryProperty> {
  QueryBuilder<RecentlyUsed, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentlyUsed, int, QQueryOperations> createAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createAt');
    });
  }

  QueryBuilder<RecentlyUsed, String, QQueryOperations> routerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'router');
    });
  }

  QueryBuilder<RecentlyUsed, String, QQueryOperations> toolNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toolName');
    });
  }
}
