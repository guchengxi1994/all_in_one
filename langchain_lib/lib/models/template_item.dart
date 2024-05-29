import 'dart:convert';

import 'package:langchain_lib/models/appflowy_model.dart';

class TemplateItem {
  final String prompt;
  final int index;
  int? next;
  final AttributeType attrType;
  final String? extra;

  TemplateItem({
    required this.prompt,
    required this.index,
    this.next,
    required this.attrType,
    this.extra,
  });
}

enum AttributeType {
  Prompt,
  File,
  Sql,
}

List<(String, AttributeType, String?)>? getAllCandidates(String s) {
  final v = <(String, AttributeType, String?)>[];
  final doc = Root.fromJson(jsonDecode(s));
  final re = RegExp(r'\{\{(.*?)\}\}');
  final children = doc.document.children;

  for (final i in children) {
    if (i.data.delta.isNotEmpty) {
      for (final d in i.data.delta) {
        for (final match in re.allMatches(d.insert)) {
          print('Matched text: ${match.group(0)}');
          v.add((match.group(0)!, AttributeType.Prompt, null));
        }

        // Since the structure of `d.attributes` isn't defined, assuming it's a Map<String, dynamic>
        final Attributes? attributes = d.attributes;

        if (attributes != null && attributes.sql != null) {
          v.add((d.insert, AttributeType.Sql, attributes.sql));
        }

        if (attributes != null && attributes.file != null) {
          v.add((d.insert, AttributeType.File, attributes.file));
        }
      }
    }
  }

  return v;
}

List<(String, AttributeType, String?)> templateToPrompts(
    {required String template}) {
  return getAllCandidates(template) ?? [];
}
