import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/chatchat_config.dart';
import 'package:all_in_one/llm/global/components/history_list.dart';
import 'package:flutter/material.dart';

import 'components/chat_ui.dart';

class ChatChatScreen extends StatelessWidget {
  const ChatChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const HistoryList(
            llmType: LLMType.chatchat,
          ),
          Expanded(child: ChatUI(config: ChatchatConfig()))
        ],
      ),
    );
  }
}
