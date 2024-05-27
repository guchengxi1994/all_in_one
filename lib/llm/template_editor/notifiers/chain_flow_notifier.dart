import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langchain_lib/models/template_item.dart';

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

  Future<List<(String, int, int?, AttributeType, String?)>> toRust() async {
    List<(String, int, int?, AttributeType, String?)> result = [];
    // final items = await templateToPrompts(template: state.content);
    // final itemTuple = items
    //     .mapIndexed(
    //         (index, element) => ((index, element.$1, element.$2, element.$3)))
    //     .toList();

    // List<int> ids = [];
    // for (final i in state.items) {
    //   ids.addAll(i.ids);
    //   for (int j = 0; j < i.ids.length; j++) {
    //     if (j < i.ids.length - 1) {
    //       result.add((
    //         i.contents[j],
    //         i.ids[j],
    //         ids[j + 1],
    //         AttributeType.prompt,
    //         null
    //       ));
    //     } else {
    //       result
    //           .add((i.contents[j], i.ids[j], null, AttributeType.prompt, null));
    //     }
    //   }
    // }

    // itemTuple.retainWhere((element) => !ids.contains(element.$1));

    // for (final t in itemTuple) {
    //   result.add((t.$2, t.$1, null, t.$3, t.$4));
    // }

    return result;
  }
}

final chainFlowProvider = NotifierProvider<ChainFlowNotifier, ChainFlowState>(
  () => ChainFlowNotifier(),
);
