import 'dart:ui';

import 'package:all_in_one/llm/plugins/models/mind_map_model.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';

const nodeHeight = 50.0;
const gap = 20.0;
const elementSize = Size(200, 50);
const elementKind = ElementKind.rectangle;
const elementFontSize = 14.0;

extension ToMindMap on Dashboard {
  loadFromMap(Map<String, dynamic> map) {
    removeAllElements(notify: false);
    int count = countLeafNodes(map);
    MindMapData mindMapData = MindMapData.fromJson(map);
    // add root
    String subject = mindMapData.subject ?? "root";
    addElement(
        FlowElement(
            text: subject,
            textSize: elementFontSize,
            kind: elementKind,
            position: Offset(100, count * (nodeHeight + gap) / 2)),
        notify: false);
  }
}

List<Map<String, dynamic>> flattenMap(Map<String, dynamic> map,
    {int level = 0, String? path = ""}) {
  List<Map<String, dynamic>> result = [];

  map.forEach((key, value) {
    String currentPath = path == null ? key : "$path.$key";

    if (value is Map) {
      // 如果值是Map，递归调用flattenMap
      result.addAll(flattenMap(value as Map<String, dynamic>,
          level: level + 1, path: currentPath));
    } else if (value is List) {
      // 如果值是列表，遍历列表中的每个元素
      for (int index = 0; index < value.length; index++) {
        if (value[index] is Map) {
          // 对列表中的Map递归处理
          result.addAll(flattenMap(
              Map.fromEntries([MapEntry(currentPath, value[index])]),
              level: level + 1,
              path: "$currentPath[$index]"));
        } else {
          // 直接添加非Map元素
          result.add({
            "level": level + 1,
            "index": index,
            "key": currentPath,
            "value": value[index],
          });
        }
      }
    } else {
      // 基本类型直接添加
      result.add({
        "level": level,
        "index": -1, // 或者根据需要处理，这里设置-1表示非列表中的项
        "key": currentPath,
        "value": value,
      });
    }
  });

  return result;
}

int countLeafNodes(Map<dynamic, dynamic> map) {
  int count = 0;
  map.forEach((key, value) {
    if (value is Map) {
      // 如果值是Map，则递归计数
      count += countLeafNodes(value);
    } else {
      // 如果值不是Map，计数加一
      count++;
    }
  });
  return count;
}

List<MapEntry<dynamic, dynamic>> collectLeafNodes(Map<dynamic, dynamic> map) {
  List<MapEntry<dynamic, dynamic>> leafEntries = [];
  map.forEach((key, value) {
    if (value is Map) {
      // 如果值是Map，则递归收集
      leafEntries.addAll(collectLeafNodes(value));
    } else {
      // 如果值不是Map，收集键值对
      leafEntries.add(MapEntry(key, value));
    }
  });
  return leafEntries;
}
