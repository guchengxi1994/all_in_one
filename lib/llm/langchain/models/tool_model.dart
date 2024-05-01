import 'package:all_in_one/src/rust/llm.dart';

class ToolModel {
  final String imgPath;
  final String systemPrompt;
  final String name;

  ToolModel(
      {required this.imgPath, required this.systemPrompt, required this.name});

  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
        imgPath: json['img_path'],
        systemPrompt: json['system_prompt'],
        name: json['name']);
  }

  LLMMessage toMessage() {
    return LLMMessage(uuid: "", content: systemPrompt, type: 1);
  }
}
