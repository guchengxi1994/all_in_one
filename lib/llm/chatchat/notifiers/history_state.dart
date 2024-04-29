import 'package:all_in_one/isar/llm_history.dart';

class HistoryState {
  List<LLMHistory> history;
  int current;

  HistoryState({
    this.history = const [],
    this.current = 0,
  });
}
