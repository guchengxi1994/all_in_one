import 'dart:ui';

import 'package:all_in_one/src/rust/llm/app_flowy_model.dart';

class ChainFlowState {
  final String content;
  final ChainFlowItem items;

  ChainFlowState({required this.items, this.content = ""});

  ChainFlowState copyWith(ChainFlowItem? items, String? content) {
    return ChainFlowState(
        items: items ?? this.items, content: content ?? this.content);
  }
}

extension Group on ChainFlowItem {
  List<List<Offset>> getBounds() {
    if (connections.isEmpty) {
      return [];
    }
    List<List<Offset>> results = [];
    for (final i in connections) {
      final src = flowItems.where((v) => v.uuid == i.$1).first;
      final dest = flowItems.where((v) => v.uuid == i.$2).first;
      // print(src.index);
      // print(dest.index);
      results.add([
        Offset(100, src.index * 50 + 25),
        Offset(100, dest.index * 50 + 25)
      ]);
    }

    return results;
  }

  List<(String, String)> getConnections() {
    if (connections.isEmpty) {
      return [];
    }

    List<(String, String)> results = [];

    for (final i in connections) {
      final src = flowItems.where((v) => v.uuid == i.$1).first;
      final dest = flowItems.where((v) => v.uuid == i.$2).first;
      // print(src.index);
      // print(dest.index);
      results.add((src.content, dest.content));
    }

    return results;
  }
}

class ChainFlowItem {
  final Set<FlowItem> flowItems;
  final List<(String, String)> connections;

  ChainFlowItem({this.connections = const [], this.flowItems = const {}});
}

class FlowItem {
  final String content;
  final String uuid;
  final AttributeType type;
  final String? extra;
  final int index;

  FlowItem(
      {required this.content,
      required this.uuid,
      required this.type,
      this.extra,
      required this.index});

  @override
  String toString() {
    return "uuid: $uuid; content: $content";
  }

  @override
  bool operator ==(Object other) {
    if (other is! FlowItem) {
      return false;
    }
    return other.content == content && uuid == other.uuid;
  }

  @override
  int get hashCode => content.hashCode ^ uuid.hashCode;
}
