import 'package:langchain/langchain.dart';

class MessageUtil {
  MessageUtil._();
  static ChatMessage createSystemMessage(final String content) {
    return SystemChatMessage(content: content);
  }

  static ChatMessage createHumanMessage(
      /* support text only right now */ final String content) {
    return HumanChatMessage(content: ChatMessageContentText(text: content));
  }

  static ChatMessage createAiMessage(final String content) {
    return AIChatMessage(content: content);
  }

  static ChatMessage createToolMessage(
      final String content, final String toolId) {
    return ToolChatMessage(content: content, toolCallId: toolId);
  }
}
