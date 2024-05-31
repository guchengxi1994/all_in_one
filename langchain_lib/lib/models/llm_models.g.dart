// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LlmModels _$LlmModelsFromJson(Map<String, dynamic> json) => LlmModels(
      models: (json['models'] as List<dynamic>)
          .map((e) => Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LlmModelsToJson(LlmModels instance) => <String, dynamic>{
      'models': instance.models,
    };

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      llmBase: json['llm-base'] as String,
      llmModelName: json['llm-model-name'] as String,
      llmSk: json['llm-sk'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'tag': instance.tag,
      'llm-base': instance.llmBase,
      'llm-model-name': instance.llmModelName,
      'llm-sk': instance.llmSk,
    };
