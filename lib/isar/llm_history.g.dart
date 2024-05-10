// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLLMHistoryCollection on Isar {
  IsarCollection<LLMHistory> get lLMHistorys => this.collection();
}

const LLMHistorySchema = CollectionSchema(
  name: r'LLMHistory',
  id: -6383495881006753143,
  properties: {
    r'chatTag': PropertySchema(
      id: 0,
      name: r'chatTag',
      type: IsarType.string,
    ),
    r'createAt': PropertySchema(
      id: 1,
      name: r'createAt',
      type: IsarType.long,
    ),
    r'llmType': PropertySchema(
      id: 2,
      name: r'llmType',
      type: IsarType.byte,
      enumMap: _LLMHistoryllmTypeEnumValueMap,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _lLMHistoryEstimateSize,
  serialize: _lLMHistorySerialize,
  deserialize: _lLMHistoryDeserialize,
  deserializeProp: _lLMHistoryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'messages': LinkSchema(
      id: 8439486342948873563,
      name: r'messages',
      target: r'LLMHistoryMessage',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _lLMHistoryGetId,
  getLinks: _lLMHistoryGetLinks,
  attach: _lLMHistoryAttach,
  version: '3.1.0+1',
);

int _lLMHistoryEstimateSize(
  LLMHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chatTag.length * 3;
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _lLMHistorySerialize(
  LLMHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chatTag);
  writer.writeLong(offsets[1], object.createAt);
  writer.writeByte(offsets[2], object.llmType.index);
  writer.writeString(offsets[3], object.title);
}

LLMHistory _lLMHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LLMHistory();
  object.chatTag = reader.readString(offsets[0]);
  object.createAt = reader.readLong(offsets[1]);
  object.id = id;
  object.llmType =
      _LLMHistoryllmTypeValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          LLMType.openai;
  object.title = reader.readStringOrNull(offsets[3]);
  return object;
}

P _lLMHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (_LLMHistoryllmTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          LLMType.openai) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LLMHistoryllmTypeEnumValueMap = {
  'openai': 0,
  'chatchat': 1,
};
const _LLMHistoryllmTypeValueEnumMap = {
  0: LLMType.openai,
  1: LLMType.chatchat,
};

Id _lLMHistoryGetId(LLMHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lLMHistoryGetLinks(LLMHistory object) {
  return [object.messages];
}

void _lLMHistoryAttach(IsarCollection<dynamic> col, Id id, LLMHistory object) {
  object.id = id;
  object.messages
      .attach(col, col.isar.collection<LLMHistoryMessage>(), r'messages', id);
}

extension LLMHistoryQueryWhereSort
    on QueryBuilder<LLMHistory, LLMHistory, QWhere> {
  QueryBuilder<LLMHistory, LLMHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LLMHistoryQueryWhere
    on QueryBuilder<LLMHistory, LLMHistory, QWhereClause> {
  QueryBuilder<LLMHistory, LLMHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LLMHistory, LLMHistory, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterWhereClause> idBetween(
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

extension LLMHistoryQueryFilter
    on QueryBuilder<LLMHistory, LLMHistory, QFilterCondition> {
  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      chatTagGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatTag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatTag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> chatTagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatTag',
        value: '',
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      chatTagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatTag',
        value: '',
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> createAtEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
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

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> createAtLessThan(
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

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> createAtBetween(
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

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> llmTypeEqualTo(
      LLMType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'llmType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      llmTypeGreaterThan(
    LLMType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'llmType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> llmTypeLessThan(
    LLMType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'llmType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> llmTypeBetween(
    LLMType lower,
    LLMType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'llmType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension LLMHistoryQueryObject
    on QueryBuilder<LLMHistory, LLMHistory, QFilterCondition> {}

extension LLMHistoryQueryLinks
    on QueryBuilder<LLMHistory, LLMHistory, QFilterCondition> {
  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition> messages(
      FilterQuery<LLMHistoryMessage> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'messages');
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      messagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', length, true, length, true);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      messagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, true, 0, true);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      messagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, false, 999999, true);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      messagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, true, length, include);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      messagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', length, include, 999999, true);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterFilterCondition>
      messagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'messages', lower, includeLower, upper, includeUpper);
    });
  }
}

extension LLMHistoryQuerySortBy
    on QueryBuilder<LLMHistory, LLMHistory, QSortBy> {
  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByChatTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatTag', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByChatTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatTag', Sort.desc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByLlmType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llmType', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByLlmTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llmType', Sort.desc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension LLMHistoryQuerySortThenBy
    on QueryBuilder<LLMHistory, LLMHistory, QSortThenBy> {
  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByChatTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatTag', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByChatTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatTag', Sort.desc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByLlmType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llmType', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByLlmTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llmType', Sort.desc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension LLMHistoryQueryWhereDistinct
    on QueryBuilder<LLMHistory, LLMHistory, QDistinct> {
  QueryBuilder<LLMHistory, LLMHistory, QDistinct> distinctByChatTag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatTag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QDistinct> distinctByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createAt');
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QDistinct> distinctByLlmType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'llmType');
    });
  }

  QueryBuilder<LLMHistory, LLMHistory, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension LLMHistoryQueryProperty
    on QueryBuilder<LLMHistory, LLMHistory, QQueryProperty> {
  QueryBuilder<LLMHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LLMHistory, String, QQueryOperations> chatTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatTag');
    });
  }

  QueryBuilder<LLMHistory, int, QQueryOperations> createAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createAt');
    });
  }

  QueryBuilder<LLMHistory, LLMType, QQueryOperations> llmTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'llmType');
    });
  }

  QueryBuilder<LLMHistory, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLLMHistoryMessageCollection on Isar {
  IsarCollection<LLMHistoryMessage> get lLMHistoryMessages => this.collection();
}

const LLMHistoryMessageSchema = CollectionSchema(
  name: r'LLMHistoryMessage',
  id: -4672365974127735365,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'messageType': PropertySchema(
      id: 1,
      name: r'messageType',
      type: IsarType.byte,
      enumMap: _LLMHistoryMessagemessageTypeEnumValueMap,
    ),
    r'roleType': PropertySchema(
      id: 2,
      name: r'roleType',
      type: IsarType.long,
    )
  },
  estimateSize: _lLMHistoryMessageEstimateSize,
  serialize: _lLMHistoryMessageSerialize,
  deserialize: _lLMHistoryMessageDeserialize,
  deserializeProp: _lLMHistoryMessageDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _lLMHistoryMessageGetId,
  getLinks: _lLMHistoryMessageGetLinks,
  attach: _lLMHistoryMessageAttach,
  version: '3.1.0+1',
);

int _lLMHistoryMessageEstimateSize(
  LLMHistoryMessage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.content;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _lLMHistoryMessageSerialize(
  LLMHistoryMessage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeByte(offsets[1], object.messageType.index);
  writer.writeLong(offsets[2], object.roleType);
}

LLMHistoryMessage _lLMHistoryMessageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LLMHistoryMessage();
  object.content = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.messageType = _LLMHistoryMessagemessageTypeValueEnumMap[
          reader.readByteOrNull(offsets[1])] ??
      MessageType.query;
  object.roleType = reader.readLong(offsets[2]);
  return object;
}

P _lLMHistoryMessageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (_LLMHistoryMessagemessageTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MessageType.query) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LLMHistoryMessagemessageTypeEnumValueMap = {
  'query': 0,
  'response': 1,
};
const _LLMHistoryMessagemessageTypeValueEnumMap = {
  0: MessageType.query,
  1: MessageType.response,
};

Id _lLMHistoryMessageGetId(LLMHistoryMessage object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lLMHistoryMessageGetLinks(
    LLMHistoryMessage object) {
  return [];
}

void _lLMHistoryMessageAttach(
    IsarCollection<dynamic> col, Id id, LLMHistoryMessage object) {
  object.id = id;
}

extension LLMHistoryMessageQueryWhereSort
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QWhere> {
  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LLMHistoryMessageQueryWhere
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QWhereClause> {
  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterWhereClause>
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

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterWhereClause>
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
}

extension LLMHistoryMessageQueryFilter
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QFilterCondition> {
  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
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

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
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

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
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

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      messageTypeEqualTo(MessageType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      messageTypeGreaterThan(
    MessageType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      messageTypeLessThan(
    MessageType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      messageTypeBetween(
    MessageType lower,
    MessageType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      roleTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      roleTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roleType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      roleTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roleType',
        value: value,
      ));
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterFilterCondition>
      roleTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roleType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LLMHistoryMessageQueryObject
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QFilterCondition> {}

extension LLMHistoryMessageQueryLinks
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QFilterCondition> {}

extension LLMHistoryMessageQuerySortBy
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QSortBy> {
  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      sortByMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.asc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      sortByMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.desc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      sortByRoleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleType', Sort.asc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      sortByRoleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleType', Sort.desc);
    });
  }
}

extension LLMHistoryMessageQuerySortThenBy
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QSortThenBy> {
  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      thenByMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.asc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      thenByMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.desc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      thenByRoleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleType', Sort.asc);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QAfterSortBy>
      thenByRoleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleType', Sort.desc);
    });
  }
}

extension LLMHistoryMessageQueryWhereDistinct
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QDistinct> {
  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QDistinct>
      distinctByContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QDistinct>
      distinctByMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageType');
    });
  }

  QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QDistinct>
      distinctByRoleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roleType');
    });
  }
}

extension LLMHistoryMessageQueryProperty
    on QueryBuilder<LLMHistoryMessage, LLMHistoryMessage, QQueryProperty> {
  QueryBuilder<LLMHistoryMessage, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LLMHistoryMessage, String?, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<LLMHistoryMessage, MessageType, QQueryOperations>
      messageTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageType');
    });
  }

  QueryBuilder<LLMHistoryMessage, int, QQueryOperations> roleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roleType');
    });
  }
}
