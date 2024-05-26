import 'package:langchain/langchain.dart';
import 'package:langchain_lib/client/client.dart';
import 'package:langchain_lib/models/template_item.dart';
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

  @override
  BaseChain? intoChain(List<TemplateItem> items) {
    if (items.isEmpty) {
      return null;
    }
    if (items.length == 1) {
      final prompt = LLMChain(
          llm: model, prompt: PromptTemplate.fromTemplate(items[0].prompt));

      return prompt;
    } else {
      // final prompt = SequentialChain(chains: []);
      List<BaseChain> chains = [];
      for (int i = 0; i < items.length; i++) {
        String input = "input$i";
        String output = "input${i + 1}";
        String promptStr;
        if (i == 0) {
          promptStr = "请根据以下要求，帮我生成对应的文案。 {$input}";
        } else {
          promptStr =
              "请根据以下内容和额外要求，帮我生成对应的文案。内容: {$input}, 额外要求: ${items[i].prompt}";
        }
        print(promptStr);
        final prompt = PromptTemplate.fromTemplate(promptStr);
        // chains.add()
        final chain = LLMChain(llm: model, prompt: prompt, outputKey: output);
        chains.add(chain);
      }
      final seqChain = SequentialChain(
          chains: chains,
          // memory: const SimpleMemory(),
          returnIntermediateOutputs: true);
      return seqChain;
    }
  }
}
