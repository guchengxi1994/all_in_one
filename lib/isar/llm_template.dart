import 'package:isar/isar.dart';

part 'llm_template.g.dart';

@collection
class LlmTemplate {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  late String name;
  late String template;
  late String templateContent = "";
  late String chains = "";

  @override
  bool operator ==(Object other) {
    return other is LlmTemplate && other.id == id && other.template == template;
  }

  @override
  int get hashCode => template.hashCode;
}
