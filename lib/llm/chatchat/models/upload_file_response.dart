// ignore_for_file: library_private_types_in_public_api, unused_element

class UploadFileResponse {
  int? code;
  String? msg;
  _Data? data;

  UploadFileResponse({this.code, this.msg, this.data});

  UploadFileResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? _Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class _Data {
  String? id;
  List<String>? failedFiles;

  _Data({this.id, this.failedFiles});

  _Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    failedFiles = json['failed_files'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['failed_files'] = failedFiles;
    return data;
  }
}
