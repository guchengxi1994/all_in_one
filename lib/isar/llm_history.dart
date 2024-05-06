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
  late String chatTag = "随便聊聊";

  final messages = IsarLinks<LLMHistoryMessage>();
}

enum MessageType { query, response }

@collection
class LLMHistoryMessage {
  @enumerated
  late MessageType messageType;

  Id id = Isar.autoIncrement;
  late int roleType = 0;

  String? content;
}
