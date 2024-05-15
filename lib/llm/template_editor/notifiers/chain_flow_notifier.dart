import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:all_in_one/src/rust/llm/app_flowy_model.dart';
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
  Future<List<(String, int, int?, AttributeType)>> toRust() async {
    List<(String, int, int?, AttributeType)> result = [];
    final items = await templateToPrompts(template: state.content);
    final itemTuple = items
        .mapIndexed((index, element) => ((index, element.$1, element.$2)))
        .toList();

    List<int> ids = [];
    for (final i in state.items) {
      ids.addAll(i.ids);
      for (int j = 0; j < i.ids.length; j++) {
        if (j < i.ids.length - 1) {
          result
              .add((i.contents[j], i.ids[j], ids[j + 1], AttributeType.prompt));
        } else {
          result.add((i.contents[j], i.ids[j], null, AttributeType.prompt));
        }
      }
    }

    itemTuple.retainWhere((element) => !ids.contains(element.$1));

    for (final t in itemTuple) {
      result.add((t.$2, t.$1, null, t.$3));
    }

    return result;
  }

  clear() {
    state = state.copyWith({}, "");
  }

  /// 这里需要添加逻辑
  /// 一个prompt不能出现
  /// 在多个链中
  removeItem(int id) {
    final items = Set<ChainFlowItem>.from(state.items)
      ..removeWhere((element) => element.ids.contains(id));
    state = state.copyWith(items.cast<ChainFlowItem>(), null);
  }
}

final chainFlowProvider = NotifierProvider<ChainFlowNotifier, ChainFlowState>(
  () => ChainFlowNotifier(),
);
