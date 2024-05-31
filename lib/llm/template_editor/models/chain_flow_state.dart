import 'dart:ui';

import 'package:all_in_one/llm/ai_client.dart';
import 'package:langchain_lib/models/template_item.dart';

class ChainFlowState {
  final String content;
  final ChainFlowItem items;

  ChainFlowState({required this.items, this.content = ""});

  ChainFlowState copyWith(ChainFlowItem? items, String? content) {
    return ChainFlowState(
        items: items ?? this.items, content: content ?? this.content);
  }
}

extension Eval on ChainFlowItem {
  Future<Map<String, dynamic>> eval(AiClient client) async {
    List<TemplateItem> items = [];

    List<String> flattened = [];
    for (final i in connections) {
      flattened.addAll([i.$1, i.$2]);
    }

    List<List<TemplateItem>> chains = [];

    for (int i = 0; i < flowItems.length; i++) {
      final template = TemplateItem(
          attrType: flowItems.elementAt(i).type,
          prompt: flowItems.elementAt(i).content,
          index: flowItems.elementAt(i).index,
          extra: flowItems.elementAt(i).extra);

      if (flattened.contains(flowItems.elementAt(i).uuid)) {
        items.add(template);
      } else {
        chains.add([template]);
      }
    }

    for (final i in connections) {
      final first = flowItems.where((v) => v.uuid == i.$1).first;
      final firstItem = items.where((v) => v.index == first.index).first;
      final second = flowItems.where((v) => v.uuid == i.$2).first;
      final secondItem = items.where((v) => v.index == second.index).first;
      firstItem.next = second.index;

      chains.add([firstItem, secondItem]);
    }

    Map<String, dynamic> result = {};

    // print(chains);
    for (final i in chains) {
      result.addAll(await client.invokeChainWithTemplateItems(i));
    }

    return result;
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

  Map<String, dynamic> toJson() => {
        'connections': connections.map((e) => {e.$1: e.$2}).toList(),
        'flowItems': flowItems.map((e) => e.toJson()).toList(),
      };

  factory ChainFlowItem.fromJson(Map<String, dynamic> json) {
    late Set<FlowItem> s = <FlowItem>{};
    if (json['flowItems'] != null) {
      json['flowItems'].forEach((v) {
        s.add(FlowItem.fromJson(v));
      });
    }
    late List<(String, String)> c = [];
    if (json['connections'] != null && json['connections'].isNotEmpty) {
      // print(json['connections']);
      // json['connections'].forEach((Map v) {
      //   // s.add(FlowItem.fromJson(v));
      //   c.add((v.entries.first.key, v.entries.first.value));
      // });
      for (Map v in json['connections']) {
        c.add((v.entries.first.key, v.entries.first.value));
      }
    }
    return ChainFlowItem(flowItems: s, connections: c);
  }

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

  Map<String, dynamic> toJson() => {
        'content': content,
        'uuid': uuid,
        'type': type.toJson(),
        'extra': extra,
        'index': index,
      };

  factory FlowItem.fromJson(Map<String, dynamic> json) {
    return FlowItem(
      content: json['content'] ?? '',
      uuid: json['uuid'] ?? '',
      type: attrFromJson(json['type']),
      extra: json['extra'],
      index: json['index'] ?? 0,
    );
  }

  @override
  int get hashCode => content.hashCode ^ uuid.hashCode;
}

extension AttrExtension on AttributeType {
  int toJson() {
    return AttributeType.values.indexOf(this);
  }
}

AttributeType attrFromJson(int index) {
  return AttributeType.values[index];
}
