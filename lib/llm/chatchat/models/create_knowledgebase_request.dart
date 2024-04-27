class CreateKnowledgeBaseRequest {
  String? knowledgeBaseName;
  String? vectorStoreType;
  String? embedModel;

  CreateKnowledgeBaseRequest(
      {this.knowledgeBaseName, this.vectorStoreType, this.embedModel});

  CreateKnowledgeBaseRequest.fromJson(Map<String, dynamic> json) {
    knowledgeBaseName = json['knowledge_base_name'];
    vectorStoreType = json['vector_store_type'];
    embedModel = json['embed_model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['knowledge_base_name'] = knowledgeBaseName;
    data['vector_store_type'] = vectorStoreType;
    data['embed_model'] = embedModel;
    return data;
  }
}
