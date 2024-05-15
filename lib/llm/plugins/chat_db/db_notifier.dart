import 'package:all_in_one/src/rust/llm/plugins/chat_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DbNotifierState {
  final Set<DatabaseInfo> info;

  DbNotifierState({
    required this.info,
  });
}

class DbNotifier extends Notifier<DbNotifierState> {
  @override
  DbNotifierState build() {
    return DbNotifierState(info: {});
  }

  addDatasource(DatabaseInfo info) {
    state = DbNotifierState(info: {...state.info, info});
  }
}

final dbNotifierProvider =
    NotifierProvider<DbNotifier, DbNotifierState>(() => DbNotifier());
