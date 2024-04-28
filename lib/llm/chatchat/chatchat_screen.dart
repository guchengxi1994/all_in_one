import 'package:all_in_one/llm/chatchat/chatchat_config.dart';
import 'package:flutter/material.dart';

import 'components/chat_ui.dart';
import 'components/history_item_widget.dart';

class ChatChatScreen extends StatelessWidget {
  const ChatChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const HistoryList(),
          Expanded(child: ChatUI(config: ChatchatConfig()))
        ],
      ),
    );
  }
}
