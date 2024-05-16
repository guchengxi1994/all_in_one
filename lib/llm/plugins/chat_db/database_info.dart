import 'package:all_in_one/src/rust/llm/plugins/chat_db.dart';
import 'package:isar/isar.dart';

part 'database_info.g.dart';

@collection
class ChatDbDatabaseInfo {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  late String name;
  late String address;
  late String port;
  late String username;
  late String password;
  late String database;
}

extension ToChatDb on DatabaseInfo {
  static DatabaseInfo fromChatDbDatabaseInfo(ChatDbDatabaseInfo info) {
    return DatabaseInfo(
        name: info.name,
        address: info.address,
        port: info.port,
        username: info.username,
        password: info.password,
        database: info.database);
  }

  ChatDbDatabaseInfo toChatDbDatabaseInfo() {
    return ChatDbDatabaseInfo()
      ..address = address
      ..database = database
      ..name = name
      ..password = password
      ..port = port
      ..username = username;
  }
}
