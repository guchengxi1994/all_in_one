import 'package:langchain/langchain.dart';
import 'package:langchain_lib/client/client.dart';
import 'package:langchain_openai/langchain_openai.dart';

import 'load_env.dart';

class OpenaiClient extends Client {
  final String baseUrl;
  final String? apiKey;
  final String? modelName;

  OpenaiClient({required this.baseUrl, this.apiKey, this.modelName}) {
    model = ChatOpenAI(
        apiKey: apiKey,
        baseUrl: baseUrl,
        defaultOptions: ChatOpenAIOptions(model: modelName));
  }

  late final ChatOpenAI model;

  @override
  Future<ChatResult> invoke(List<ChatMessage> history) async {
    final prompt = PromptValue.chat(history);
    return await model.invoke(prompt);
  }

  @override
  Stream<ChatResult> stream(List<ChatMessage> history) {
    final prompt = PromptValue.chat(history);
    return model.stream(prompt);
  }

  static Client? fromEnv(String path) {
    final envs = loadEnv(path);
    if (envs.length != 3) {
      return OpenaiClient(baseUrl: "");
    }

    return OpenaiClient(baseUrl: envs[0], apiKey: envs[2], modelName: envs[1]);
  }
}
