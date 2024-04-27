class FileChatRequest {
  String? query;
  String? knowledgeId;
  int? topK;
  double? scoreThreshold;
  List<History>? history;
  bool? stream;
  String? modelName;
  double? temperature;
  int? maxTokens;
  String? promptName;

  FileChatRequest(
      {this.query,
      this.knowledgeId,
      this.topK,
      this.scoreThreshold,
      this.history,
      this.stream,
      this.modelName,
      this.temperature,
      this.maxTokens,
      this.promptName});

  FileChatRequest.fromJson(Map<String, dynamic> json) {
    query = json['query'];
    knowledgeId = json['knowledge_id'];
    topK = json['top_k'];
    scoreThreshold = json['score_threshold'];
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
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
    data['knowledge_id'] = knowledgeId;
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

class History {
  String? role;
  String? content;

  History({this.role, this.content});

  History.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['content'] = content;
    return data;
  }
}
