// ignore_for_file: avoid_print

import 'dart:ui';

class MindMapData {
  String? subject;
  List<SubNodes>? subNodes;

  MindMapData({this.subject, this.subNodes});

  MindMapData.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    if (json['subNodes'] != null) {
      subNodes = [];
      json['subNodes'].forEach((v) {
        subNodes!.add(SubNodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    if (subNodes != null) {
      data['subNodes'] = subNodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Map<String, dynamic>> flattenNodes() {
    List<Map<String, dynamic>> flatList = [];
    _flatten(this, flatList, 0);
    return flatList;
  }

  void _flatten(dynamic node, List<Map<String, dynamic>> flatList, int level) {
    if (node is MindMapData) {
      flatList.add({"level": level, "key": "subject", "value": node.subject});
      if (node.subNodes != null) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          _flatten(node.subNodes![i], flatList, level + 1);
        }
      }
    } else if (node is SubNodes) {
      flatList.add({"level": level, "key": "node", "value": node.node});
      flatList.add(
          {"level": level, "key": "description", "value": node.description});
      if (node.subNodes != null) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          _flatten(node.subNodes![i], flatList, level + 1);
        }
      }
    }
  }

  List<Map<String, dynamic>> flattenNodesWithIndex() {
    List<Map<String, dynamic>> flatList = [];
    _flattenWithIndex(this, flatList, 0, -1); // 初始父级索引设为-1，表示根节点
    return flatList;
  }

  void _flattenWithIndex(
      dynamic node, List<Map<String, dynamic>> flatList, int level,
      [int parentIndex = -1]) {
    if (node is MindMapData) {
      flatList.add({
        "level": level,
        "index": parentIndex + 1, // 根节点索引为0
        "key": "subject",
        "value": node.subject
      });
      if (node.subNodes != null) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          _flattenWithIndex(node.subNodes![i], flatList, level + 1, i);
        }
      }
    } else if (node is SubNodes) {
      flatList.add({
        "level": level,
        "index": parentIndex + 1, // 继承上一级的索引
        "key": "node",
        "value": node.node
      });
      flatList.add({
        "level": level,
        "index": parentIndex + 1, // 同上，保持与"node"相同的索引
        "key": "description",
        "value": node.description
      });
      if (node.subNodes != null) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          _flattenWithIndex(node.subNodes![i], flatList, level + 1, i);
        }
      }
    }
  }

  List<Map<String, dynamic>> flattenNodesWithOffset(
      {required Offset rootOffset}) {
    List<Map<String, dynamic>> flatList = [];
    _flattenWithOffsetAndIndex(
        this, flatList, 0, -1, rootOffset); // 初始父级索引设为-1，表示根节点
    return flatList;
  }

  void _flattenWithOffsetAndIndex(
      dynamic node,
      List<Map<String, dynamic>> flatList,
      int level,
      int parentIndex,
      Offset currentOffset) {
    if (node is MindMapData) {
      flatList.add({
        "level": level,
        "index": parentIndex + 1,
        "key": "subject",
        "value": node.subject,
        "offset": currentOffset.toString()
      });
      if (node.subNodes != null) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          Offset childOffset = Offset(currentOffset.dx + 200 * (level + 1),
              currentOffset.dy + 50 * (level + 1));
          _flattenWithOffsetAndIndex(
              node.subNodes![i], flatList, level + 1, i, childOffset);
        }
      }
    } else if (node is SubNodes) {
      flatList.add({
        "level": level,
        "index": parentIndex + 1,
        "key": "node",
        "value": node.node,
        "description": node.description,
        "offset": currentOffset.toString()
      });
      // 检查是否有子节点且不为空，若有则继续递归；若无，则已到达叶子节点，停止递归
      if (node.subNodes != null && node.subNodes!.isNotEmpty) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          Offset childOffset = Offset(currentOffset.dx + 200 * (level + 1),
              currentOffset.dy + 50 * (level + 1));
          _flattenWithOffsetAndIndex(
              node.subNodes![i], flatList, level + 1, i, childOffset);
        }
      }
    }
  }
}

class SubNodes {
  String? node;
  String? description;
  List<SubNodes>? subNodes;

  SubNodes({this.node, this.description, this.subNodes});

  SubNodes.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    description = json['description'];
    if (json['subNodes'] != null) {
      subNodes = [];
      json['subNodes'].forEach((v) {
        subNodes!.add(SubNodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['description'] = description;
    if (subNodes != null) {
      data['subNodes'] = subNodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

void main() {
  Map<String, dynamic> nestedMap = {
    "subject": "主主题",
    "subNodes": [
      {
        "node": "子节点1",
        "description": "子节点1的描述",
        "subNodes": [
          {"node": "子节点1.1", "description": "子节点1.1的描述"},
          {"node": "子节点1.2", "description": "子节点1.2的描述"}
        ]
      },
      {"node": "子节点2", "description": "子节点2的描述"}
    ]
  };

  MindMapData mapData = MindMapData.fromJson(nestedMap);

  List<Map<String, dynamic>> flattened = mapData.flattenNodesWithIndex();
  for (final v in flattened) {
    print(v);
  }
  print("===================================================================");
  List<Map<String, dynamic>> flattenedOffset =
      mapData.flattenNodesWithOffset(rootOffset: const Offset(100, 100));
  for (final v in flattenedOffset) {
    print(v);
  }
}
