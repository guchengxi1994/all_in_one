import 'dart:ui';

import 'package:uuid/uuid.dart';

const nodeHeight = 50.0;
const nodeWidth = 300.0;
const gap = 20.0;

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

  List<Map<String, dynamic>> flattenNodesWithOffset(
      {required Offset rootOffset}) {
    List<Map<String, dynamic>> flatList = [];
    _flattenWithOffsetAndIndex(this, flatList, 0, -1, rootOffset,
        const Uuid().v4()); // 初始父级索引设为-1，表示根节点
    return flatList;
  }

  void _flattenWithOffsetAndIndex(
      dynamic node,
      List<Map<String, dynamic>> flatList,
      int level,
      int parentIndex,
      Offset currentOffset,
      String parentUuid) {
    if (node is MindMapData) {
      String nodeUuid = const Uuid().v4();
      flatList.add({
        "level": level,
        "index": parentIndex + 1,
        "key": "subject",
        "value": node.subject,
        "offset": currentOffset,
        "uuid": nodeUuid,
        "parentUuid": parentUuid
      });
      if (node.subNodes != null) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          Offset childOffset = Offset(currentOffset.dx + nodeWidth * (1),
              currentOffset.dy + (gap + nodeHeight) * (i + 1));
          _flattenWithOffsetAndIndex(node.subNodes![i], flatList, level + 1, i,
              childOffset - const Offset(0, (gap + nodeHeight)), nodeUuid);
        }
      }
    } else if (node is SubNodes) {
      String nodeUuid = const Uuid().v4();
      flatList.add({
        "level": level,
        "index": parentIndex + 1,
        "key": "node",
        "value": node.node,
        "description": node.description,
        "offset": currentOffset,
        "uuid": nodeUuid,
        "parentUuid": parentUuid
      });
      // 检查是否有子节点且不为空，若有则继续递归；若无，则已到达叶子节点，停止递归
      if (node.subNodes != null && node.subNodes!.isNotEmpty) {
        for (int i = 0; i < node.subNodes!.length; i++) {
          Offset childOffset = Offset(currentOffset.dx + nodeWidth * (1),
              currentOffset.dy + (gap + nodeHeight) * (i + 1));
          _flattenWithOffsetAndIndex(node.subNodes![i], flatList, level + 1, i,
              childOffset - const Offset(0, (gap + nodeHeight)), nodeUuid);
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
