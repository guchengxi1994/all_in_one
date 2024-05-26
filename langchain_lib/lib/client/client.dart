import 'package:langchain/langchain.dart';

abstract class Client {
  Future<ChatResult> invoke(List<ChatMessage> history);

  Stream<ChatResult> stream(List<ChatMessage> history);
}
