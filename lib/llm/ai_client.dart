import 'package:all_in_one/common/logger.dart';
import 'package:langchain_lib/client/client.dart';
import 'package:langchain_lib/langchain_lib.dart';

class AiClient {
  AiClient._();

  static final _instance = AiClient._();

  factory AiClient() => _instance;

  late Client? client;
  initOpenAi(String path) {
    client = OpenaiClient.fromEnv(path);
  }

  Stream<ChatResult> optimizeDocStream(String doc) {
    final history = [
      MessageUtil.createSystemMessage(
          "你是一个专业的作家，适合优化文章脉络和措辞，使得文章表达更加详实、具体，观点清晰。"),
      MessageUtil.createHumanMessage(
          "请帮我改写优化以下文章。注意：1.进行文章改写时请尽量使用简体中文。\n2.只改写优化<rewrite> </rewrite>标签中的部分。\n3.保留<keep> </keep>标签中的内容。\n4.最终结果中删除<rewrite> </rewrite> <keep> </keep>标签。"),
      MessageUtil.createHumanMessage(doc)
    ];

    return client!.stream(history);
  }

  Future<ChatResult?> optimizeDoc(String doc) async {
    final history = [
      MessageUtil.createSystemMessage(
          "你是一个专业的作家，适合优化文章脉络和措辞，使得文章表达更加详实、具体，观点清晰。"),
      MessageUtil.createHumanMessage(
          "请帮我改写优化以下文章。注意：1.进行文章改写时请尽量使用简体中文。\n2.只改写优化<rewrite> </rewrite>标签中的部分。\n3.保留<keep> </keep>标签中的内容。\n4.最终结果中删除<rewrite> </rewrite> <keep> </keep>标签。"),
      MessageUtil.createHumanMessage(doc)
    ];
    int tryTimes = 0;
    // ignore: avoid_init_to_null
    late ChatResult? result = null;

    while (tryTimes < client!.maxTryTimes) {
      tryTimes += 1;
      // print(tryTimes);
      logger.info(
          "Retrying $tryTimes times, remaining ${client!.maxTryTimes - tryTimes} times");
      try {
        result = await client!.invoke(history);
        break;
      } catch (e) {
        // logger.severe(e.toString());
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return result;
  }

  Stream<ChatResult> textToMindMap(String text) {
    final history = [
      MessageUtil.createSystemMessage("你是一个专业的分析师，善于整理思维导图。"),
      MessageUtil.createHumanMessage(
          "请帮我将以下内容转为思维导图json格式。注意：1.只需要返回json。2. json格式参考 { \"subject\":\"string\",\"subNodes\":[ { \"node\":\"string\",\" description \":\"string\",\"subNodes\":[ { \"node\":\"string\",\" description \":\"string\" } ] } ] } 。3. json不需要换行。"),
      MessageUtil.createHumanMessage(text)
    ];
    return client!.stream(history);
  }
}
