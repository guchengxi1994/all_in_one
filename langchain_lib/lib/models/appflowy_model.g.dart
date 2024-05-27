// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appflowy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Root _$RootFromJson(Map<String, dynamic> json) => Root(
      document: Document.fromJson(json['document'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RootToJson(Root instance) => <String, dynamic>{
      'document': instance.document,
    };

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      typeField: json['typeField'] as String,
      children: (json['children'] as List<dynamic>)
          .map((e) => Children.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'typeField': instance.typeField,
      'children': instance.children,
    };

Children _$ChildrenFromJson(Map<String, dynamic> json) => Children(
      typeField: json['typeField'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChildrenToJson(Children instance) => <String, dynamic>{
      'typeField': instance.typeField,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      level: (json['level'] as num?)?.toInt(),
      delta: (json['delta'] as List<dynamic>)
          .map((e) => Delum.fromJson(e as Map<String, dynamic>))
          .toList(),
      align: json['align'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'level': instance.level,
      'delta': instance.delta,
      'align': instance.align,
    };

Delum _$DelumFromJson(Map<String, dynamic> json) => Delum(
      insert: json['insert'] as String,
      attributes: json['attributes'] == null
          ? null
          : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DelumToJson(Delum instance) => <String, dynamic>{
      'insert': instance.insert,
      'attributes': instance.attributes,
    };

Attributes _$AttributesFromJson(Map<String, dynamic> json) => Attributes(
      bold: json['bold'] as bool?,
      italic: json['italic'] as bool?,
      file: json['file'] as String?,
      sql: json['sql'] as String?,
    );

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{
      'bold': instance.bold,
      'italic': instance.italic,
      'file': instance.file,
      'sql': instance.sql,
    };
