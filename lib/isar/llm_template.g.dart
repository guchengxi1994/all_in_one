// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLlmTemplateCollection on Isar {
  IsarCollection<LlmTemplate> get llmTemplates => this.collection();
}

const LlmTemplateSchema = CollectionSchema(
  name: r'LlmTemplate',
  id: -7349507314354301866,
  properties: {
    r'chains': PropertySchema(
      id: 0,
      name: r'chains',
      type: IsarType.string,
    ),
    r'createAt': PropertySchema(
      id: 1,
      name: r'createAt',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'template': PropertySchema(
      id: 4,
      name: r'template',
      type: IsarType.string,
    ),
    r'templateContent': PropertySchema(
      id: 5,
      name: r'templateContent',
      type: IsarType.string,
    )
  },
  estimateSize: _llmTemplateEstimateSize,
  serialize: _llmTemplateSerialize,
  deserialize: _llmTemplateDeserialize,
  deserializeProp: _llmTemplateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _llmTemplateGetId,
  getLinks: _llmTemplateGetLinks,
  attach: _llmTemplateAttach,
  version: '3.1.0+1',
);

int _llmTemplateEstimateSize(
  LlmTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chains.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.template.length * 3;
  bytesCount += 3 + object.templateContent.length * 3;
  return bytesCount;
}

void _llmTemplateSerialize(
  LlmTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chains);
  writer.writeLong(offsets[1], object.createAt);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.template);
  writer.writeString(offsets[5], object.templateContent);
}

LlmTemplate _llmTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LlmTemplate();
  object.chains = reader.readString(offsets[0]);
  object.createAt = reader.readLong(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[3]);
  object.template = reader.readString(offsets[4]);
  object.templateContent = reader.readString(offsets[5]);
  return object;
}

P _llmTemplateDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _llmTemplateGetId(LlmTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _llmTemplateGetLinks(LlmTemplate object) {
  return [];
}

void _llmTemplateAttach(
    IsarCollection<dynamic> col, Id id, LlmTemplate object) {
  object.id = id;
}

extension LlmTemplateQueryWhereSort
    on QueryBuilder<LlmTemplate, LlmTemplate, QWhere> {
  QueryBuilder<LlmTemplate, LlmTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LlmTemplateQueryWhere
    on QueryBuilder<LlmTemplate, LlmTemplate, QWhereClause> {
  QueryBuilder<LlmTemplate, LlmTemplate, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterWhereClause> idBetween(
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

extension LlmTemplateQueryFilter
    on QueryBuilder<LlmTemplate, LlmTemplate, QFilterCondition> {
  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> chainsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chains',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      chainsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chains',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> chainsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chains',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> chainsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chains',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      chainsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chains',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> chainsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chains',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> chainsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chains',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> chainsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chains',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      chainsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chains',
        value: '',
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      chainsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chains',
        value: '',
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> createAtEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
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

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
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

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> createAtBetween(
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

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> templateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> templateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'template',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition> templateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'template',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'template',
        value: '',
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'template',
        value: '',
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'templateContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'templateContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'templateContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'templateContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'templateContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'templateContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'templateContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateContent',
        value: '',
      ));
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterFilterCondition>
      templateContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'templateContent',
        value: '',
      ));
    });
  }
}

extension LlmTemplateQueryObject
    on QueryBuilder<LlmTemplate, LlmTemplate, QFilterCondition> {}

extension LlmTemplateQueryLinks
    on QueryBuilder<LlmTemplate, LlmTemplate, QFilterCondition> {}

extension LlmTemplateQuerySortBy
    on QueryBuilder<LlmTemplate, LlmTemplate, QSortBy> {
  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByChains() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chains', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByChainsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chains', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> sortByTemplateContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateContent', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy>
      sortByTemplateContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateContent', Sort.desc);
    });
  }
}

extension LlmTemplateQuerySortThenBy
    on QueryBuilder<LlmTemplate, LlmTemplate, QSortThenBy> {
  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByChains() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chains', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByChainsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chains', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.desc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy> thenByTemplateContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateContent', Sort.asc);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QAfterSortBy>
      thenByTemplateContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateContent', Sort.desc);
    });
  }
}

extension LlmTemplateQueryWhereDistinct
    on QueryBuilder<LlmTemplate, LlmTemplate, QDistinct> {
  QueryBuilder<LlmTemplate, LlmTemplate, QDistinct> distinctByChains(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chains', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QDistinct> distinctByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createAt');
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QDistinct> distinctByTemplate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'template', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LlmTemplate, LlmTemplate, QDistinct> distinctByTemplateContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'templateContent',
          caseSensitive: caseSensitive);
    });
  }
}

extension LlmTemplateQueryProperty
    on QueryBuilder<LlmTemplate, LlmTemplate, QQueryProperty> {
  QueryBuilder<LlmTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LlmTemplate, String, QQueryOperations> chainsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chains');
    });
  }

  QueryBuilder<LlmTemplate, int, QQueryOperations> createAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createAt');
    });
  }

  QueryBuilder<LlmTemplate, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<LlmTemplate, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LlmTemplate, String, QQueryOperations> templateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'template');
    });
  }

  QueryBuilder<LlmTemplate, String, QQueryOperations>
      templateContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'templateContent');
    });
  }
}
