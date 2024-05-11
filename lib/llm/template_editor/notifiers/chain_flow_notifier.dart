import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chain_flow_state.dart';

class ChainFlowNotifier extends Notifier<ChainFlowState> {
  @override
  ChainFlowState build() {
    return ChainFlowState();
  }

  changeContent(String s) {
    if (state.content != s) {
      state = state.copyWith(null, s);
    }
  }

  addItem(ChainFlowItem item) {
    final items = Set.from(state.items)..add(item);
    state = state.copyWith(items.cast<ChainFlowItem>(), null);
  }

  /// FIXME
  /// BUG
  /// 不灵活的实现方案
  Future<List<(String, int, int?)>> toRust() async {
    List<(String, int, int?)> result = [];
    if (state.items.isEmpty) {
      final items = await templateToPrompts(template: state.content);
      result =
          items.mapIndexed((index, element) => (element, index, null)).toList();
    } else {
      for (final i in state.items) {
        result.add((i.startContent, i.start, i.end));
        result.add((i.endContent, i.end, null));
      }
    }

    return result;
  }

  removeItem(int start, int end) {
    ChainFlowItem item =
        ChainFlowItem(end: end, endContent: "", start: start, startContent: "");
    final items = Set.from(state.items)..remove(item);
    state = state.copyWith(items.cast<ChainFlowItem>(), null);
  }
}

final chainFlowProvider = NotifierProvider<ChainFlowNotifier, ChainFlowState>(
  () => ChainFlowNotifier(),
);
