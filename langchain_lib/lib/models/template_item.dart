class TemplateItem {
  final String prompt;
  final int index;
  final int? next;
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
