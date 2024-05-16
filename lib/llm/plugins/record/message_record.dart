import 'package:all_in_one/isar/llm_history.dart' show MessageType;
import 'package:isar/isar.dart';

part 'message_record.g.dart';

@collection
class MessageRecord {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  late String content;
  @enumerated
  late MessageType messageType = MessageType.query;
}
