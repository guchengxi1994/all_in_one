import 'package:all_in_one/src/rust/llm.dart';

class ToolModel {
  final String imgPath;
  final String systemPrompt;
  final String name;
  final String type;

  ToolModel(
      {required this.imgPath,
      required this.systemPrompt,
      required this.name,
      required this.type});

  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      imgPath: json['img_path'],
      systemPrompt: json['system_prompt'],
      name: json['name'],
      type: json['type'],
    );
  }

  LLMMessage? toMessage() {
    if (type != "tool") {
      return null;
    }
    return LLMMessage(uuid: "", content: systemPrompt, type: 1);
  }
}
