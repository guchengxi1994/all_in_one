import 'package:all_in_one/common/logger.dart';
import 'package:all_in_one/src/rust/api/llm_plugin_api.dart';
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
    final role =
        getPromptByName(key: "role-define", module: "template-optimize") ??
            "you are a good writer";
    final insPrompt = getPromptByName(
            key: "instruction-define", module: "template-optimize") ??
        "Rewrite this article in chinese";

    final history = [
      MessageUtil.createSystemMessage(role),
      MessageUtil.createHumanMessage(insPrompt),
      MessageUtil.createHumanMessage(doc)
    ];

    return client!.stream(history);
  }

  Future<ChatResult?> optimizeDoc(String doc) async {
    final role =
        getPromptByName(key: "role-define", module: "template-optimize");
    if (role == null) {
      return null;
    }
    final insPrompt =
        getPromptByName(key: "instruction-define", module: "template-optimize");
    if (insPrompt == null) {
      return null;
    }
    final history = [
      MessageUtil.createSystemMessage(role),
      MessageUtil.createHumanMessage(insPrompt),
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
    final role = getPromptByName(key: "role-define", module: "conversion") ??
        "you are a good analyst";
    final insPrompt = getPromptByName(
            key: "convert-file-to-mind-map", module: "conversion") ??
        "convert this article to json";

    final history = [
      MessageUtil.createSystemMessage(role),
      MessageUtil.createHumanMessage(insPrompt),
      MessageUtil.createHumanMessage(text)
    ];
    return client!.stream(history);
  }
}
