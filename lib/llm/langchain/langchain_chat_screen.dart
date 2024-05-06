import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/global/components/history_list.dart';
import 'package:all_in_one/llm/langchain/components/buttons.dart';
import 'package:all_in_one/llm/langchain/components/chat_ui.dart';
import 'package:all_in_one/llm/langchain/components/tools_screen.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/seq_chain_flow.dart';

class LangchainChatScreen extends ConsumerStatefulWidget {
  const LangchainChatScreen({super.key});

  @override
  ConsumerState<LangchainChatScreen> createState() =>
      _LangchainChatScreenState();
}

class _LangchainChatScreenState extends ConsumerState<LangchainChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: ref.read(toolProvider.notifier).controller,
        children: const [ToolsScreen(), _UI(), FlowScreen()],
      ),
    );
  }
}

class _UI extends StatelessWidget {
  const _UI();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        HistoryList(
          llmType: LLMType.openai,
          bottom: Buttons(),
        ),
        Expanded(child: ChatUI())
      ],
    );
  }
}
