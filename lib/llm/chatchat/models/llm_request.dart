import 'history.dart';

class LLMRequest {
  String? query;
  String? conversationId;
  int? historyLen;
  List<IHistory>? history;
  bool? stream;
  String? modelName;
  double? temperature;
  int? maxTokens;
  String? promptName;

  LLMRequest(
      {this.query,
      this.conversationId = "",
      this.historyLen = -1,
      this.history = const [],
      this.stream,
      this.modelName,
      this.temperature = 0.7,
      this.maxTokens = 0,
      this.promptName = "default"});

  LLMRequest.fromJson(Map<String, dynamic> json) {
    query = json['query'];
    conversationId = json['conversation_id'];
    historyLen = json['history_len'];
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
    data['conversation_id'] = conversationId;
    data['history_len'] = historyLen;
    // data['history'] = history;
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
