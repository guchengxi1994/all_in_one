import 'package:isar/isar.dart';
part 'llm_history.g.dart';

enum LLMType { openai, chatchat }

@collection
class LLMHistory {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  String? title;
  @enumerated
  late LLMType llmType = LLMType.openai;

  final messages = IsarLinks<LLMHistoryMessages>();
}

enum MessageType { query, response }

@collection
class LLMHistoryMessages {
  @enumerated
  late MessageType messageType;

  Id id = Isar.autoIncrement;

  String? content;
}
