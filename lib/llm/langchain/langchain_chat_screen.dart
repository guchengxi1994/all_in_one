import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/components/history_item_widget.dart';
import 'package:all_in_one/llm/langchain/components/chat_ui.dart';
import 'package:flutter/material.dart';

class LangchainChatScreen extends StatefulWidget {
  const LangchainChatScreen({super.key});

  @override
  State<LangchainChatScreen> createState() => _LangchainChatScreenState();
}

class _LangchainChatScreenState extends State<LangchainChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          HistoryList(
            llmType: LLMType.openai,
          ),
          Expanded(child: ChatUI())
        ],
      ),
    );
  }
}
