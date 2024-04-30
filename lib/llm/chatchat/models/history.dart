abstract class IHistory {
  abstract String role;

  Map<String, dynamic> toJson();
}

class UserHistory extends IHistory {
  @override
  String role = "user";
  String? content;

  UserHistory({this.content});

  UserHistory.fromJson(Map<String, dynamic> json) {
    role = "user";
    content = json['content'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = "user";
    data['content'] = content;
    return data;
  }
}

class AssistantHistory extends IHistory {
  @override
  String role = "assistant";
  String? content;

  AssistantHistory({this.content});

  AssistantHistory.fromJson(Map<String, dynamic> json) {
    role = "assistant";
    content = json['content'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = "assistant";
    data['content'] = content;
    return data;
  }
}
