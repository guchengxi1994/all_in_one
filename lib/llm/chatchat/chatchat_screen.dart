import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/chatchat_config.dart';
import 'package:all_in_one/llm/global/components/history_list.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/chat_ui.dart';

class ChatChatScreen extends ConsumerWidget {
  const ChatChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatTag = ref.read(toolProvider)?.name;
    return Scaffold(
      body: Row(
        children: [
          HistoryList(
            llmType: LLMType.chatchat,
            chatTag: chatTag ?? "随便聊聊",
          ),
          Expanded(
              child: ChatUI(
            config: ChatchatConfig(),
            chatTag: chatTag ?? "随便聊聊",
          ))
        ],
      ),
    );
  }
}
