import 'package:langchain/langchain.dart';
import 'package:langchain_lib/models/template_item.dart';

abstract class Client {
  Future<ChatResult> invoke(List<ChatMessage> history);

  Stream<ChatResult> stream(List<ChatMessage> history);

  BaseChain? intoChain(List<TemplateItem> items);

  Future<Map<String, dynamic>> invokeChain(
      BaseChain chain, int chainLength, String input);

  Future<Map<String, dynamic>> invokeChainWithTemplateItems(
      List<TemplateItem> items);
}
