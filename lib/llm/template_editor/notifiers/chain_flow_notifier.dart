import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chain_flow_state.dart';

class ChainFlowNotifier extends AutoDisposeNotifier<ChainFlowState> {
  @override
  ChainFlowState build() {
    return ChainFlowState();
  }

  addItem(ChainFlowItem item) {
    final items = Set.from(state.items)..add(item);
    state = state.copyWith(items.cast<ChainFlowItem>());
  }

  removeItem(int start, int end) {
    ChainFlowItem item =
        ChainFlowItem(end: end, endContent: "", start: start, startContent: "");
    final items = Set.from(state.items)..remove(item);
    state = state.copyWith(items.cast<ChainFlowItem>());
  }
}

final chainFlowProvider =
    AutoDisposeNotifierProvider<ChainFlowNotifier, ChainFlowState>(
  () => ChainFlowNotifier(),
);
