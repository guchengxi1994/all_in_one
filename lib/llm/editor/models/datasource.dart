import 'dart:convert';
import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';

enum DatasourceType { markdown, json }

class Datasource {
  final DatasourceType type;
  final String? filepath;
  final String? content;

  late String data;

  @override
  bool operator ==(Object other) {
    return other is Datasource &&
        other.type == type &&
        other.filepath == filepath &&
        other.content == content;
  }

  Datasource(
      {this.type = DatasourceType.markdown, this.filepath, this.content}) {
    assert(filepath != null || content != null);
    if (filepath != null) {
      assert(File(filepath!).existsSync());
      data = File(filepath!).readAsStringSync();
    } else {
      data = content!;
    }
  }

  Document toDocument() {
    if (type == DatasourceType.json) {
      return Document.fromJson(jsonDecode(data));
    } else {
      return markdownToDocument(data);
    }
  }

  @override
  int get hashCode => filepath.hashCode ^ content.hashCode ^ type.hashCode;
}
