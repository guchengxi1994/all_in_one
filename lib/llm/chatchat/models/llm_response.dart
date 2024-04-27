import 'chat_response.dart';

class LLMResponse extends ChatResponse {
  String? text;
  String? messageId;

  LLMResponse({this.text, this.messageId});

  LLMResponse.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    messageId = json['message_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['message_id'] = messageId;
    return data;
  }

  @override
  String get content => text ?? "";
}
