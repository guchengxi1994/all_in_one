class MindMapData {
  String? subject;
  List<SubNodes>? subNodes;

  MindMapData({this.subject, this.subNodes});

  MindMapData.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    if (json['subNodes'] != null) {
      subNodes = <SubNodes>[];
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
      subNodes = <SubNodes>[];
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
