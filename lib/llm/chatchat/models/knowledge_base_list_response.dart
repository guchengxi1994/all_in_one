class KnowledgeBaseListResponse {
  int? code;
  String? msg;
  List<String>? data;

  KnowledgeBaseListResponse({this.code, this.msg, this.data});

  KnowledgeBaseListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['data'] = this.data;
    return data;
  }
}
