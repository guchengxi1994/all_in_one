import 'package:all_in_one/llm/chatchat/models/message_box.dart';

class MessageState {
  List<MessageBox> messageBox;
  bool isLoading = false;
  bool isKnowledgeBaseChat = false;

  MessageState(
      {this.messageBox = const [],
      this.isLoading = false,
      this.isKnowledgeBaseChat = false});
}
