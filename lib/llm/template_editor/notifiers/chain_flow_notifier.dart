import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chain_flow_state.dart';

class ChainFlowNotifier extends Notifier<ChainFlowState> {
  @override
  ChainFlowState build() {
    return ChainFlowState(items: ChainFlowItem());
  }

  changeContent(String s) {
    if (state.content != s) {
      state = state.copyWith(null, s);
    }
  }

  addAllItems(List<FlowItem> items) {
    // final s = Set<FlowItem>.from(state.items.flowItems)..addAll(items);

    state = state.copyWith(
        ChainFlowItem(
            connections: state.items.connections, flowItems: items.toSet()),
        null);
  }

  bool addConnection(String srcId, String destId) {
    final connections = state.items.connections;
    bool couldAdd = true;

    for (final i in connections) {
      if (i.$1 == srcId) {
        couldAdd = false;
        break;
      }
      if (i.$2 == destId) {
        couldAdd = false;
        break;
      }
    }

    if (couldAdd) {
      connections.add((srcId, destId));
      state = state.copyWith(
          ChainFlowItem(
              connections: connections, flowItems: state.items.flowItems),
          null);
    }

    return couldAdd;
  }

  clear() {
    state = state.copyWith(ChainFlowItem(connections: [], flowItems: {}), "");
  }

  removeConnection((String, String) s) {
    final connections = List<(String, String)>.from(state.items.connections)
      ..remove(s);
    state = state.copyWith(
        ChainFlowItem(
            connections: connections, flowItems: state.items.flowItems),
        state.content);
  }
}

final chainFlowProvider = NotifierProvider<ChainFlowNotifier, ChainFlowState>(
  () => ChainFlowNotifier(),
);
