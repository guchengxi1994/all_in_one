// ignore_for_file: avoid_print

List<Map<String, dynamic>> flattenMap(Map<String, dynamic> map,
    {int level = 0}) {
  List<Map<String, dynamic>> result = [];

  map.forEach((key, value) {
    String currentPath = key;

    if (value is Map) {
      // 如果值是Map，递归调用flattenMap
      result
          .addAll(flattenMap(value as Map<String, dynamic>, level: level + 1));
    } else if (value is List) {
      // 如果值是列表，遍历列表中的每个元素
      for (int index = 0; index < value.length; index++) {
        if (value[index] is Map) {
          // 对列表中的Map递归处理
          result.addAll(flattenMap(
            Map.fromEntries([MapEntry(currentPath, value[index])]),
            level: level + 1,
          ));
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

  List<Map<String, dynamic>> flattened = flattenMap(nestedMap);
  print(flattened);
}


/**
 
  
 import 'dart:convert';

void main() {
  String jsonStr = '''
  {
    "subject": "主主题",
    "subNodes": [
      {
        "node": "子节点1",
        "description": "子节点1的描述",
        "subNodes": [
          {
            "node": "子节点1.1",
            "description": "子节点1.1的描述"
          },
          {
            "node": "子节点1.2",
            "description": "子节点1.2的描述"
          }
        ]
      },
      {
        "node": "子节点2",
        "description": "子节点2的描述"
      }
    ]
  }
  ''';

  Map<String, dynamic> jsonData = jsonDecode(jsonStr);
  List<Map<String, dynamic>> flatList = [];
  
  void flatten(Map<String, dynamic> data, int level = 0, String? path = "") {
    data.forEach((key, value) {
      String currentPath = path == null ? key : "$path.$key";
      if (value is Map<String, dynamic>) {
        flatten(value, level + 1, currentPath);
      } else if (value is List<dynamic>) {
        for (int i = 0; i < value.length; i++) {
          if (value[i] is Map<String, dynamic>) {
            flatten(value[i], level + 1, "$currentPath[$i]");
          } else {
            flatList.add({
              "level": level + 1,
              "index": i,
              "key": "$currentPath[$i]",
              "value": value[i]
            });
          }
        }
      } else {
        flatList.add({
          "level": level,
          "index": null,
          "key": currentPath,
          "value": value
        });
      }
    });
  }

  flatten(jsonData);
  
  flatList.forEach((item) => print(item));
} 
 */
