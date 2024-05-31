import 'package:langchain/langchain.dart';
import 'package:langchain_lib/client/load_env.dart';
import 'package:langchain_lib/models/llm_models.dart';
import 'package:langchain_openai/langchain_openai.dart';

main() async {
  LlmModels? envs = loadEnv(r"D:\github_repo\all_in_one\env.json");
  if (envs == null) {
    return;
  }

  final client = envs.find(tag: "vision-model");
  final llm = ChatOpenAI(
    apiKey: client!.llmSk,
    baseUrl: client.llmBase,
    defaultOptions: ChatOpenAIOptions(
      model: client.llmModelName,
    ),
  );
  final prompt = PromptValue.chat([
    // ChatMessage.system(
    //   'You are a helpful assistant.',
    // ),
    ChatMessage.human(
      ChatMessageContent.multiModal([
        ChatMessageContent.text('What is this?'),
        ChatMessageContent.image(
          data:
              "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg",
        ),
      ]),
    ),
  ]);

  for (final i in prompt.toChatMessages()) {
    print(i);
  }

  final res = await llm.invoke(prompt);

  print(res.outputAsString);
}
