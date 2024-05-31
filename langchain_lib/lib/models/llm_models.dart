import 'package:json_annotation/json_annotation.dart';

part 'llm_models.g.dart';

@JsonSerializable()
class LlmModels {
  final List<Model> models;

  LlmModels({required this.models});

  factory LlmModels.fromJson(Map<String, dynamic> json) =>
      _$LlmModelsFromJson(json);
  Map<String, dynamic> toJson() => _$LlmModelsToJson(this);

  Model? find({required String tag}) {
    return models.where((v) => v.tag == tag).firstOrNull;
  }
}

@JsonSerializable()
class Model {
  final String tag;
  @JsonKey(name: "llm-base")
  final String llmBase;
  @JsonKey(name: "llm-model-name")
  final String llmModelName;
  @JsonKey(name: "llm-sk")
  final String llmSk;

  Model(
      {required this.llmBase,
      required this.llmModelName,
      required this.llmSk,
      required this.tag});

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}
