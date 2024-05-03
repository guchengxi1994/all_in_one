import 'package:all_in_one/llm/langchain/models/chains.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChainNotifier extends Notifier<Map<FlowElement, ChainItem>> {
  @override
  Map<FlowElement, ChainItem> build() {
    return {};
  }

  addItem(FlowElement element, ChainItem chainItem) {
    state[element] = chainItem;
  }

  removeItem(String id) {
    state.removeWhere((key, value) => key.id == id);
  }

  updateItem(FlowElement element, ChainItem chainItem) {
    state[element] = chainItem;
  }

  bool validate() {
    final values = state.values;
    if (values.isEmpty) {
      return false;
    }
    if (values.elementAt(0).inputKey == null ||
        values.elementAt(0).outputKey == null ||
        values.elementAt(0).prompt == null) {
      return false;
    }
    for (int i = 0; i < values.length - 1; i++) {
      if (values.elementAt(i).outputKey == null ||
          values.elementAt(i + 1).inputKey != values.elementAt(i).outputKey ||
          values.elementAt(i).prompt == null ||
          values.elementAt(i + 1).prompt == null) {
        return false;
      }
    }
    return true;
  }

  List<ChainItem> get items => state.values.toList();
}

final chainProvider =
    NotifierProvider<ChainNotifier, Map<FlowElement, ChainItem>>(
  () => ChainNotifier(),
);
