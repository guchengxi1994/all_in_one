import 'package:isar/isar.dart';

part 'llm_template.g.dart';

@collection
class LlmTemplate {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  late String name;
  late String template;
  late String chains = "";
}
