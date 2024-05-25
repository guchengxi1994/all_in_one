import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/editor/compose_screen.dart';
import 'package:all_in_one/llm/global/components/history_list.dart';
import 'package:all_in_one/llm/langchain/components/buttons.dart';
import 'package:all_in_one/llm/langchain/components/chat_ui.dart';
import 'package:all_in_one/llm/langchain/components/tools_screen.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/llm/template_editor/template_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'langchain/components/seq_chain_flow.dart';

class AIAssistantScreen extends ConsumerWidget {
  const AIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: ref.read(toolProvider.notifier).controller,
        children: const [
          ToolsScreen(),
          _UI(),
          FlowScreen(),
          TemplateEditor(),
          ComposeScreen()
        ],
      ),
    );
  }
}

class _UI extends ConsumerWidget {
  const _UI();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatTag = ref.read(toolProvider)?.name;
    return Row(
      children: [
        HistoryList(
          llmType: LLMType.openai,
          bottom: const Buttons(),
          chatTag: chatTag ?? "随便聊聊",
        ),
        Expanded(
            child: ChatUI(
          chatTag: chatTag ?? "随便聊聊",
        ))
      ],
    );
  }
}
