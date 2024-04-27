import 'package:isar/isar.dart';
part 'llm_history.g.dart';

@collection
class LLMHistory {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  String? title;

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
