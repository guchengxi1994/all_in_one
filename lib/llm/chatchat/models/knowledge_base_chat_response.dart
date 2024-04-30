import 'chat_response.dart';

class KnowledgeBaseChatResponse extends ChatResponse {
  String? answer;
  List<String>? docs;

  KnowledgeBaseChatResponse({this.answer, this.docs});

  KnowledgeBaseChatResponse.fromJson(Map<String, dynamic> json) {
    // print("json    $json");
    answer = json['answer'];
    if (json['docs'] == null) {
      docs = [];
    } else {
      docs = json['docs'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer'] = answer;
    data['docs'] = docs;
    return data;
  }

  @override
  String get content => answer ?? "";
}
