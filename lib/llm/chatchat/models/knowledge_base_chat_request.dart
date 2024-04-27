import 'history.dart';

class KnowledgeBaseChatRequest {
  String? query;
  String? knowledgeBaseName;
  int? topK;
  double? scoreThreshold;
  List<IHistory>? history;
  bool? stream;
  String? modelName;
  double? temperature;
  int? maxTokens;
  String? promptName;

  KnowledgeBaseChatRequest(
      {this.query,
      this.knowledgeBaseName,
      this.topK = 3,
      this.scoreThreshold = 2.0,
      this.history,
      this.stream = true,
      this.modelName,
      this.temperature = 0.0,
      this.maxTokens = 0,
      this.promptName = "default"});

  KnowledgeBaseChatRequest.fromJson(Map<String, dynamic> json) {
    query = json['query'];
    knowledgeBaseName = json['knowledge_base_name'];
    topK = json['top_k'];
    scoreThreshold = json['score_threshold'];
    if (json['history'] != null) {
      history = <IHistory>[];
      json['history'].forEach((v) {
        if (v['role'] == "user") {
          history!.add(UserHistory.fromJson(v));
        } else {
          history!.add(AssistantHistory.fromJson(v));
        }
      });
    }
    stream = json['stream'];
    modelName = json['model_name'];
    temperature = json['temperature'];
    maxTokens = json['max_tokens'];
    promptName = json['prompt_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['query'] = query;
    data['knowledge_base_name'] = knowledgeBaseName;
    data['top_k'] = topK;
    data['score_threshold'] = scoreThreshold;
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    data['stream'] = stream;
    data['model_name'] = modelName;
    data['temperature'] = temperature;
    data['max_tokens'] = maxTokens;
    data['prompt_name'] = promptName;
    return data;
  }
}
