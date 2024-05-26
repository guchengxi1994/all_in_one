import 'package:langchain_lib/client/client.dart';
import 'package:langchain_lib/client/openai_client.dart';
import 'package:langchain_lib/langchain_lib.dart';

class AiClient {
  AiClient._();

  static final _instance = AiClient._();

  factory AiClient() => _instance;

  late Client? client;
  initOpenAi(String path) {
    client = OpenaiClient.fromEnv(path);
  }

  Stream<ChatResult> optimizeDoc(String doc) {
    final history = [
      MessageUtil.createSystemMessage(
          "你是一个专业的作家，适合优化文章脉络和措辞，使得文章表达更加详实、具体，观点清晰。"),
      MessageUtil.createHumanMessage(
          "请帮我改写优化以下文章。注意：1.进行文章改写时请尽量使用简体中文。\n2.只改写优化<rewrite> </rewrite>标签中的部分。\n3.保留<keep> </keep>标签中的内容。\n4.最终结果中删除<rewrite> </rewrite> <keep> </keep>标签。"),
      MessageUtil.createHumanMessage(doc)
    ];

    return client!.stream(history);
  }
}
