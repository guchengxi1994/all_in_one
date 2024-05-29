import 'package:langchain_lib/client/load_env.dart';
import 'package:langchain_lib/langchain_lib.dart';
import 'package:langchain_lib/models/template_item.dart';

void main() {
  Map envs = loadEnv(r"D:\github_repo\all_in_one\env");
  if (envs.length != 3) {
    return;
  }
  final client = OpenaiClient(
      baseUrl: envs["LLM_BASE"] ?? "",
      apiKey: envs["LLM_SK"] ?? "",
      modelName: envs["LLM_MODEL_NAME"] ?? "");

  BaseChain? chain = client.intoChain([
    TemplateItem(
        prompt: "1+1等于多少",
        index: 1,
        next: null,
        attrType: AttributeType.Prompt),
  ]);

  // chain.invoke(input)
  if (chain != null) {
    client.invokeChain(chain, 1, "1+1等于多少").then((v) {
      print(v);
    });
  }
}
