import 'package:langchain_lib/client/load_env.dart';
import 'package:langchain_lib/langchain_lib.dart';
import 'package:langchain_lib/models/llm_models.dart';
import 'package:langchain_lib/models/template_item.dart';

void main() {
  LlmModels? envs = loadEnv(r"D:\github_repo\all_in_one\env.json");
  if (envs == null) {
    return;
  }

  final first = envs.find(tag: "text-model");

  final client = OpenaiClient(
      baseUrl: first!.llmBase,
      apiKey: first.llmSk,
      modelName: first.llmModelName);

  BaseChain? chain = client.intoChain([
    TemplateItem(
        prompt: "帮我梳理rust学习路线",
        index: 1,
        next: 2,
        attrType: AttributeType.Prompt),
    TemplateItem(
        prompt: "请帮我总结到200字以内", index: 2, attrType: AttributeType.Prompt)
  ]);

  // chain.invoke(input)
  if (chain != null) {
    client.invokeChain(chain, 2, "帮我梳理rust学习路线").then((v) {
      print(v.length);
      print(v);
    });
  }
}
