class Chains {
  List<ChainItem>? items;

  Chains({this.items});

  Chains.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ChainItem>[];
      json['items'].forEach((v) {
        items!.add(ChainItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChainItem {
  String? inputKey;
  String? outputKey;
  String? prompt;

  ChainItem({this.inputKey, this.outputKey, this.prompt});

  ChainItem.fromJson(Map<String, dynamic> json) {
    inputKey = json['input_key'];
    outputKey = json['output_key'];
    prompt = json['prompt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['input_key'] = inputKey;
    data['output_key'] = outputKey;
    data['prompt'] = prompt;
    return data;
  }
}
