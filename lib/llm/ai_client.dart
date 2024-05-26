import 'package:langchain_lib/client/client.dart';
import 'package:langchain_lib/client/openai_client.dart';

class AiClient {
  AiClient._();

  static final _instance = AiClient._();

  factory AiClient() => _instance;

  late Client? client;
  initOpenAi(String path) {
    client = OpenaiClient.fromEnv(path);
  }
}
