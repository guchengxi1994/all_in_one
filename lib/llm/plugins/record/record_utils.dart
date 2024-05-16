import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/llm_history.dart' show MessageType;
import 'package:all_in_one/llm/plugins/record/message_record.dart';

class RecordUtils {
  static final IsarDatabase _database = IsarDatabase();

  RecordUtils._();

  static putNewMessage(MessageType type, String content) async {
    _database.isar!.writeTxn(() async {
      _database.isar!.messageRecords.put(MessageRecord()
        ..content = content
        ..messageType = type);
    });
  }
}
